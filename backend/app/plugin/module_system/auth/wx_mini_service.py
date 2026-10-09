"""微信小程序后端服务（移植自上游 api/v1/.../wx_mini_service.py，插件化适配）。

提供以下能力：
1. code2session — 用前端 uni.login 返回的 code 换取 openid + session_key
2. get_phone_number — 用 getPhoneNumber 回调返回的 code 换取手机号（2023+ 新 API，
   无需 AES 解密）
3. get_qrcode — 调用 getwxacodeunlimit 生成小程序码
4. ensure_wx_user / ensure_wx_phone_user — 按 openid / 手机号查找或自动注册用户

所有微信 API 调用统一走 httpx.AsyncClient，access_token 通过 Redis 缓存
（TTL < 7200s）。订阅消息（subscribe send）能力按 YAGNI 原则未移植——
当前仓库无调用方，需要时可从上游补入。

与上游的适配差异：UserCRUD/AuthSchema 单参用法（auth 携带 db）、
``register_user_service`` 注册入口、``log`` 日志别名、status 为字符串约定。
"""

import json
import secrets
from typing import Any
from urllib.parse import urlencode

import httpx
from fastapi import status
from redis.asyncio.client import Redis
from sqlalchemy.ext.asyncio import AsyncSession

from app.common.enums import RedisInitKeyConfig
from app.config.setting import settings
from app.core.auth.schema import AuthSchema
from app.core.exceptions import CustomException
from app.core.logger import log
from app.core.redis_crud import RedisCURD

from ..user.crud import UserCRUD
from ..user.model import UserModel
from ..user.schema import UserRegisterSchema
from ..user.service import UserService

# 微信 API 基础地址
_WX_API_BASE = "https://api.weixin.qq.com"

# code2Session 接口
_CODE2SESSION_URL = f"{_WX_API_BASE}/sns/jscode2session"

# 获取 access_token（稳定版，推荐）
_ACCESS_TOKEN_URL = f"{_WX_API_BASE}/cgi-bin/stable_token"

# 获取手机号（2023+ 新 API）
_GET_PHONE_URL = f"{_WX_API_BASE}/wxa/business/getuserphonenumber"

# 生成无限制小程序码
_GET_QRCODE_URL = f"{_WX_API_BASE}/wxa/getwxacodeunlimit"

# 微信高频业务错误码 → 排查提示（未知错误码不附加提示，保留原始 errmsg）
_WX_ERRCODE_HINTS: dict[str, str] = {
    "40029": (
        "code 无效：请确认 WX_MINI_APP_ID 是【小程序】AppID"
        "（公众号 AppID 不支持 code2Session，只会一直报 40029），"
        "且生成 code 的小程序与它一致"
        "（开发者工具若显示“测试号”，code 是以 touristappid 签发的，必然失败）；"
        "每个 code 只能使用一次且仅 5 分钟有效"
    ),
    "40013": "AppID 无效：请核对 WX_MINI_APP_ID（须为小程序 AppID）",
    "40125": (
        "AppSecret 无效：AppID 与 AppSecret 必须来自同一个小程序"
        "（公众号的 AppSecret 不能配小程序的 AppID）"
    ),
    "40163": "code 已被使用：每次登录都必须重新调用 uni.login 获取新 code",
}


def _wx_error_detail(errcode: object, errmsg: str) -> str:
    """拼装微信错误文案：原始 errmsg + 高频错误码的排查提示。

    参数:
    - errcode (object): 微信返回的 errcode（缺失时为 None）。
    - errmsg (str): 微信返回的 errmsg。

    返回:
    - str: 可直接展示的错误文案。
    """
    hint = _WX_ERRCODE_HINTS.get(str(errcode))
    return f"{errmsg}｜{hint}" if hint else errmsg


def _require_mini_credentials() -> tuple[str, str]:
    """校验小程序 AppID / AppSecret 是否已配置。

    返回:
    - tuple[str, str]: (app_id, app_secret)

    异常:
    - CustomException: 配置为空时抛出。
    """
    app_id = settings.WX_MINI_APP_ID
    app_secret = settings.WX_MINI_APP_SECRET
    if not app_id or not app_secret:
        raise CustomException(msg="微信小程序未配置（AppID / AppSecret 为空）")
    return app_id, app_secret


async def _http_json(method: str, url: str, **kwargs: Any) -> dict:
    """发起 HTTP 请求并解析 JSON 响应。

    参数:
    - method (str): HTTP 方法。
    - url (str): 请求地址。
    - kwargs: 透传给 httpx 的参数。

    返回:
    - dict: 响应 JSON。

    异常:
    - CustomException: 非 JSON 响应时抛出。
    """
    timeout = settings.HTTPX_DEFAULT_TIMEOUT
    async with httpx.AsyncClient(timeout=timeout) as client:
        r = await client.request(method, url, **kwargs)
        r.raise_for_status()
        try:
            return r.json()
        except json.JSONDecodeError:
            log.error(f"微信 API 非 JSON 响应: {r.text[:500]}")
            raise CustomException(msg="微信接口返回异常") from None


async def _get_access_token(redis: Redis) -> str:
    """获取微信小程序 access_token，优先从 Redis 缓存读取。

    微信 access_token 有效期 7200 秒，多实例共享同一 token，必须通过中央存储
    （Redis）缓存。使用 stable_token 接口（比 cgi-bin/token 更稳定，不会因并发
    请求导致 token 互相覆盖）。

    参数:
    - redis (Redis): Redis 客户端。

    返回:
    - str: access_token。
    """
    rc = RedisCURD(redis)
    cache_key = RedisInitKeyConfig.WX_MINI_ACCESS_TOKEN.key
    cached = await rc.get(cache_key)
    if cached:
        if isinstance(cached, bytes):
            cached = cached.decode("utf-8")
        return str(cached)

    app_id, app_secret = _require_mini_credentials()
    data = await _http_json(
        "POST",
        _ACCESS_TOKEN_URL,
        json={
            "grant_type": "client_credential",
            "appid": app_id,
            "secret": app_secret,
            "force_refresh": False,
        },
    )
    token = data.get("access_token")
    if not token:
        errmsg = data.get("errmsg") or "未知错误"
        errcode = data.get("errcode")
        raise CustomException(
            msg=f"获取微信 access_token 失败: [{errcode}] {_wx_error_detail(errcode, errmsg)}",
            # 凭据/配置类问题由调用方修正，不能表现成服务端 500
            status_code=status.HTTP_400_BAD_REQUEST,
        )

    # 缓存到 Redis，TTL 比微信上限少 200 秒留余量
    ttl = settings.WX_MINI_ACCESS_TOKEN_CACHE_TTL
    await rc.set(key=cache_key, value=str(token), expire=ttl)
    log.info(f"微信小程序 access_token 已缓存，TTL={ttl}s")
    return str(token)


def _check_wx_error(data: dict, action: str) -> None:
    """统一检查微信 API 返回的 errcode。

    参数:
    - data (dict): 微信接口响应。
    - action (str): 动作描述（用于错误文案）。

    异常:
    - CustomException: errcode 非 0 时抛出，HTTP 状态码固定为 400
      （微信侧业务错误属于调用方/配置问题，不是服务端缺陷）。
    """
    errcode = data.get("errcode")
    if errcode and errcode != 0:
        errmsg = data.get("errmsg") or "未知错误"
        raise CustomException(
            msg=f"微信{action}失败: [{errcode}] {_wx_error_detail(errcode, errmsg)}",
            status_code=status.HTTP_400_BAD_REQUEST,
        )


async def code2session(code: str) -> dict:
    """用 uni.login 返回的 code 换取 openid + session_key。

    参数:
    - code (str): 前端 uni.login 返回的临时登录凭证。

    返回:
    - dict: {"openid": str, "session_key": str, "unionid": str | None}

    异常:
    - CustomException: 微信返回异常或数据不完整时抛出。
    """
    app_id, app_secret = _require_mini_credentials()
    qs = urlencode(
        {
            "appid": app_id,
            "secret": app_secret,
            "js_code": code,
            "grant_type": "authorization_code",
        }
    )
    data = await _http_json("GET", f"{_CODE2SESSION_URL}?{qs}")
    _check_wx_error(data, "code2Session")

    openid = data.get("openid")
    session_key = data.get("session_key")
    if not openid or not session_key:
        raise CustomException(msg="微信 code2Session 返回数据不完整")

    return {
        "openid": str(openid),
        "session_key": str(session_key),
        "unionid": str(data["unionid"]) if data.get("unionid") else None,
    }


async def get_phone_number(redis: Redis, code: str) -> str:
    """用 getPhoneNumber 回调返回的 code 换取手机号。

    2023+ 微信推荐方案：前端 <button open-type="getPhoneNumber"> 回调
    e.detail.code，后端调用此接口直接获取手机号，无需 AES 解密 encryptedData。

    参数:
    - redis (Redis): Redis 客户端。
    - code (str): getPhoneNumber 回调返回的动态令牌。

    返回:
    - str: 纯手机号（如 13800138000）。
    """
    access_token = await _get_access_token(redis)
    data = await _http_json(
        "POST",
        f"{_GET_PHONE_URL}?access_token={access_token}",
        json={"code": code},
    )
    _check_wx_error(data, "获取手机号")

    phone_info = data.get("phone_info")
    if not phone_info or not phone_info.get("phoneNumber"):
        raise CustomException(msg="微信返回手机号为空")

    return str(phone_info["phoneNumber"])


async def get_qrcode(redis: Redis, scene: str, page: str | None = None, width: int = 430) -> bytes:
    """生成无限制小程序码。

    调用 getwxacodeunlimit 接口，返回 PNG 图片二进制数据。
    注意：该接口返回的是图片二进制，不是 JSON。

    参数:
    - redis (Redis): Redis 客户端。
    - scene (str): 场景参数（最大 32 字符，如 "invite=abc123"）。
    - page (str | None): 小程序页面路径，为空则默认主页。
    - width (int): 图片宽度，默认 430px。

    返回:
    - bytes: PNG 图片二进制。
    """
    access_token = await _get_access_token(redis)
    payload: dict[str, Any] = {
        "scene": scene,
        "width": width,
        "auto_color": False,
        "is_hyaline": False,
    }
    if page:
        payload["page"] = page

    timeout = settings.HTTPX_DEFAULT_TIMEOUT
    async with httpx.AsyncClient(timeout=timeout) as client:
        r = await client.post(
            f"{_GET_QRCODE_URL}?access_token={access_token}",
            json=payload,
        )
        r.raise_for_status()

        # 微信接口在出错时返回 JSON（Content-Type: application/json），
        # 成功时返回 image（Content-Type: image/png 或类似）
        content_type = r.headers.get("content-type", "")
        if "json" in content_type.lower():
            try:
                err_data = r.json()
                _check_wx_error(err_data, "生成小程序码")
            except json.JSONDecodeError:
                pass
            raise CustomException(msg="生成小程序码失败") from None

        return r.content


def _username_for_wx_mini(openid: str) -> str:
    """生成符合注册规则的登录名：wxmini_{openid前20位}。

    参数:
    - openid (str): 微信小程序用户唯一标识。

    返回:
    - str: 合法用户名（≤32 字符、字母开头）。
    """
    # openid 取前 20 位，确保总长度在 32 以内
    raw = f"wxmini_{openid[:20]}"
    raw = "".join(c if c.isalnum() or c in "_-." else "_" for c in raw)[:32]
    if len(raw) < 3:
        raw = (raw + "usr")[:32]
    if not raw[0].isalpha():
        raw = "w" + raw[:31]
    return raw


async def ensure_wx_user(
    *,
    db: AsyncSession,
    openid: str,
    nickname: str | None = None,
    avatar: str | None = None,
    mobile: str | None = None,
) -> UserModel:
    """通过 openid 查找或自动注册用户。

    用户名规则：wxmini_{openid前20位}，与 OAuth 模块保持一致的风格。
    如果用户已存在但提供了新的手机号/昵称/头像，则更新这些字段。

    参数:
    - db (AsyncSession): 数据库会话。
    - openid (str): 微信小程序用户唯一标识。
    - nickname (str | None): 昵称。
    - avatar (str | None): 头像 URL。
    - mobile (str | None): 手机号。

    返回:
    - UserModel: 用户对象。
    """
    auth = AuthSchema(db=db, user=None, check_data_scope=False)
    username = _username_for_wx_mini(openid)
    existing = await UserCRUD(auth).get_by_username_crud(username=username)

    if existing:
        # 已有用户：按需更新手机号 / 昵称 / 头像（仅当新值非空且与当前不同）
        updated = False
        if mobile and existing.mobile != mobile:
            existing.mobile = mobile
            updated = True
        if nickname and existing.name != nickname:
            existing.name = nickname[:32]
            updated = True
        if avatar and existing.avatar != avatar:
            existing.avatar = avatar
            updated = True
        if updated:
            await db.flush()
        return existing

    # 自动注册新用户
    display_name = (nickname or username)[:32]
    reg = UserRegisterSchema(
        username=username,
        password=secrets.token_urlsafe(24),
        name=display_name,
        role_ids=list(settings.OAUTH_DEFAULT_ROLE_IDS),
    )
    try:
        await UserService.register_user_service(auth=auth, data=reg)
    except Exception:
        # 并发创建可能触发唯一约束冲突，回退到再次查询
        existing = await UserCRUD(auth).get_by_username_crud(username=username)
        if existing:
            return existing
        raise CustomException(msg="微信小程序用户注册失败") from None

    user = await UserCRUD(auth).get_by_username_crud(username=username)
    if not user:
        raise CustomException(msg="微信小程序用户注册失败")
    log.info(f"微信小程序自动注册用户: {username}")
    return user


async def ensure_wx_phone_user(*, db: AsyncSession, phone: str) -> UserModel:
    """通过手机号查找或自动注册用户（手机号快速登录）。

    用户名规则：wxphone_{手机号后4位}_{随机hex}（与上游一致）。

    参数:
    - db (AsyncSession): 数据库会话。
    - phone (str): 纯手机号。

    返回:
    - UserModel: 用户对象。
    """
    auth = AuthSchema(db=db, user=None, check_data_scope=False)
    existing = await UserCRUD(auth).get(mobile=phone)
    if existing:
        return existing

    username = f"wxphone_{phone[-4:]}_{secrets.token_hex(4)}"
    if not username[0].isalpha():
        username = "w" + username
    username = username[:32]

    reg = UserRegisterSchema(
        username=username,
        password=secrets.token_urlsafe(24),
        name=f"用户{phone[-4:]}",
        mobile=phone,
        role_ids=list(settings.OAUTH_DEFAULT_ROLE_IDS),
    )
    try:
        await UserService.register_user_service(auth=auth, data=reg)
    except Exception as exc:
        raise CustomException(msg="手机号用户注册失败") from exc

    user = await UserCRUD(auth).get(mobile=phone)
    if not user:
        raise CustomException(msg="手机号用户注册失败")
    log.info(f"微信手机号自动注册用户: {username}")
    return user
