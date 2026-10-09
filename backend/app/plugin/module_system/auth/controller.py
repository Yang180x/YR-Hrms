import base64
import json
import secrets
from typing import Annotated

from fastapi import APIRouter, Depends, Path, Query, Request
from fastapi.responses import JSONResponse, RedirectResponse
from redis.asyncio.client import Redis
from sqlalchemy.ext.asyncio import AsyncSession

from app.common.response import ErrorResponse, SuccessResponse
from app.config.setting import settings
from app.core.auth.schema import AuthSchema
from app.core.dependencies import db_getter, get_current_user, redis_getter
from app.core.exceptions import CustomException
from app.core.logger import log
from app.core.redis_crud import RedisCURD
from app.core.router_class import OperationLogRoute
from app.core.security import CustomOAuth2PasswordRequestForm, OAuth2Schema

from ..user.crud import UserCRUD
from .oauth_service import (
    STATE_PREFIX,
    OAuthProvider,
    _callback_url,
    build_authorize_url,
    complete_oauth_login,
    oauth_service_error_redirect,
    oauth_service_frontend_redirect_from_token,
    save_oauth_state,
)
from .schema import (
    AutoLoginTokenSchema,
    AutoLoginUserSchema,
    CaptchaOutSchema,
    JWTOutSchema,
    RefreshTokenPayloadSchema,
    WxLoginSchema,
    WxPhoneLoginSchema,
    WxQrCodeOutSchema,
    WxQrCodeSchema,
)
from .service import AutoLoginService, CaptchaService, LoginService
from .wx_mini_service import (
    code2session,
    ensure_wx_phone_user,
    ensure_wx_user,
    get_phone_number,
    get_qrcode,
)

AuthRouter = APIRouter(route_class=OperationLogRoute, prefix="/auth", tags=["认证授权"])


@AuthRouter.post(
    "/wx-login",
    summary="微信小程序登录",
    description="微信小程序登录（code2Session）",
    response_model=JWTOutSchema,
)
async def wx_mini_login_controller(
    request: Request,
    redis: Annotated[Redis, Depends(redis_getter)],
    db: Annotated[AsyncSession, Depends(db_getter)],
    body: WxLoginSchema,
) -> JSONResponse | dict:
    """微信小程序登录（code2Session）。

    前端 uni.login 获取 code → 微信 jscode2session 换 openid → 查找/自动注册用户
    → 发放双 token。与 /login 同列白名单（演示模式放行），免 access-token 调用。
    归属地异步回填由日志 sink 承接（见 log 模块，D.3）。

    参数:
    - request (Request): FastAPI请求对象。
    - redis (Redis): Redis 客户端对象。
    - db (AsyncSession): 数据库会话对象。
    - body (WxLoginSchema): code + 可选昵称/头像。

    返回:
    - JWTOutSchema: 包含访问令牌和刷新令牌的响应模型。

    异常:
    - CustomException: 未配置小程序凭据 / code 无效 / 用户已停用。
    """
    session_data = await code2session(code=body.code)
    user = await ensure_wx_user(
        db=db,
        openid=session_data["openid"],
        nickname=body.nickname,
        avatar=body.avatar,
    )
    if user.status == "1":
        raise CustomException(msg="用户已被停用")

    auth = AuthSchema(db=db, user=None, check_data_scope=False)
    user = await UserCRUD(auth).update_last_login_crud(id=user.id)
    if not user:
        raise CustomException(msg="用户不存在")

    token = await LoginService.create_token_service(
        request=request, redis=redis, user=user, login_type="WX"
    )
    log.info(f"微信小程序用户登录成功: {user.username}")

    if settings.DOCS_URL in request.headers.get("referer", ""):
        return token.model_dump()
    return SuccessResponse(data=token.model_dump(), msg="登录成功")


@AuthRouter.post(
    "/wx-phone-login",
    summary="微信小程序手机号登录",
    description="微信小程序手机号快速登录（getPhoneNumber 2023+ 新 API）",
    response_model=JWTOutSchema,
)
async def wx_mini_phone_login_controller(
    request: Request,
    redis: Annotated[Redis, Depends(redis_getter)],
    db: Annotated[AsyncSession, Depends(db_getter)],
    body: WxPhoneLoginSchema,
) -> JSONResponse | dict:
    """微信小程序手机号快速登录。

    前端 <button open-type="getPhoneNumber"> 回调 e.detail.code → 后端调
    getuserphonenumber 换手机号 → 按 mobile 查找用户，不存在则自动注册
    （用户名 wxphone_{后4位}_{随机hex}）。与 /login 同列白名单。

    参数:
    - request (Request): FastAPI请求对象。
    - redis (Redis): Redis 客户端对象。
    - db (AsyncSession): 数据库会话对象。
    - body (WxPhoneLoginSchema): getPhoneNumber 回调 code。

    返回:
    - JWTOutSchema: 包含访问令牌和刷新令牌的响应模型。

    异常:
    - CustomException: 未配置凭据 / 微信接口失败 / 用户已停用。
    """
    phone = await get_phone_number(redis=redis, code=body.code)
    user = await ensure_wx_phone_user(db=db, phone=phone)
    if user.status == "1":
        raise CustomException(msg="用户已被停用")

    auth = AuthSchema(db=db, user=None, check_data_scope=False)
    user = await UserCRUD(auth).update_last_login_crud(id=user.id)
    if not user:
        raise CustomException(msg="用户不存在")

    token = await LoginService.create_token_service(
        request=request, redis=redis, user=user, login_type="WX_PHONE"
    )
    log.info(f"微信手机号用户登录成功: {user.username}")

    if settings.DOCS_URL in request.headers.get("referer", ""):
        return token.model_dump()
    return SuccessResponse(data=token.model_dump(), msg="登录成功")


@AuthRouter.post(
    "/wx-qrcode/generate",
    summary="生成小程序码",
    description="调用微信 getwxacodeunlimit 生成小程序码（需登录）",
    response_model=WxQrCodeOutSchema,
    dependencies=[Depends(get_current_user)],
)
async def wx_qrcode_generate_controller(
    redis: Annotated[Redis, Depends(redis_getter)],
    body: WxQrCodeSchema,
) -> JSONResponse | dict:
    """生成无限制小程序码（返回 base64 data URI）。

    参数:
    - redis (Redis): Redis 客户端对象。
    - body (WxQrCodeSchema): 场景参数 / 页面路径 / 宽度。

    返回:
    - WxQrCodeOutSchema: 小程序码图片 data URI。

    异常:
    - CustomException: 未配置凭据 / 微信接口失败。
    """
    image_bytes = await get_qrcode(
        redis=redis, scene=body.scene, page=body.page, width=body.width
    )
    b64 = base64.b64encode(image_bytes).decode("utf-8")
    return SuccessResponse(
        data=WxQrCodeOutSchema(url=f"data:image/png;base64,{b64}"), msg="生成成功"
    )


@AuthRouter.post(
    "/login",
    summary="登录",
    description="登录",
    response_model=JWTOutSchema,
)
async def login_for_access_token_controller(
    request: Request,
    redis: Annotated[Redis, Depends(redis_getter)],
    login_form: Annotated[CustomOAuth2PasswordRequestForm, Depends()],
    db: Annotated[AsyncSession, Depends(db_getter)],
) -> JSONResponse | dict:
    """
    用户登录

    参数:
    - request (Request): FastAPI请求对象
    - redis (Redis): Redis 客户端对象
    - login_form (CustomOAuth2PasswordRequestForm): 登录表单数据
    - db (AsyncSession): 数据库会话对象

    返回:
    - JWTOutSchema: 包含访问令牌和刷新令牌的响应模型

    异常:
    - CustomException: 认证失败时抛出异常。
    """
    login_token = await LoginService.authenticate_user_service(
        request=request, redis=redis, login_form=login_form, db=db
    )

    log.info(f"用户{login_form.username}登录成功")

    # 如果是文档请求，则不记录日志:http://localhost:8000/api/v1/docs
    if settings.DOCS_URL in request.headers.get("referer", ""):
        return login_token.model_dump()
    return SuccessResponse(data=login_token.model_dump(), msg="登录成功")


@AuthRouter.post(
    "/token/refresh",
    summary="刷新token",
    description="刷新token",
    response_model=JWTOutSchema,
)
async def get_new_token_controller(
    request: Request,
    payload: RefreshTokenPayloadSchema,
    db: Annotated[AsyncSession, Depends(db_getter)],
    redis: Annotated[Redis, Depends(redis_getter)],
) -> JSONResponse:
    """
    刷新token

    **本路由不得挂 `Depends(get_current_user)`**：那会把「换新访问令牌」变成
    「必须先持有有效访问令牌」，而 access token 过期正是刷新要解决的场景 ——
    挂上之后本接口对过期令牌必然 401，刷新永远走不通。
    鉴权并未因此减弱，因为 `refresh_token_service` 自身就完整校验：
    签名与有效期（`decode_access_token`）、强制 `is_refresh is True`、
    回查用户是否存在，**并与 Redis 中留存的刷新令牌逐字比对**（登出即失效）。
    把 access token 当刷新令牌传进来对它毫无用处。

    参数:
    - request (Request): FastAPI请求对象
    - payload (RefreshTokenPayloadSchema): 刷新令牌负载模型
    - db (AsyncSession): 数据库会话对象
    - redis (Redis): Redis 客户端对象

    返回:
    - JWTOutSchema: 包含新的访问令牌和刷新令牌的响应模型

    异常:
    - CustomException: 刷新令牌无效/已失效时抛 401。
    """
    new_token = await LoginService.refresh_token_service(
        db=db, request=request, redis=redis, refresh_token=payload
    )
    token_dict = new_token.model_dump()
    # 只记结果，不记令牌本身：JWT 一旦写进日志，等于把可用凭证散布到日志文件
    # 与采集链路里（任何能看到日志的人都能冒充该会话）。
    log.info("刷新token成功")
    return SuccessResponse(data=token_dict, msg="刷新成功")


@AuthRouter.get(
    "/captcha/get",
    summary="获取验证码",
    description="获取登录验证码",
    response_model=CaptchaOutSchema,
)
async def get_captcha_for_login_controller(
    redis: Annotated[Redis, Depends(redis_getter)],
) -> JSONResponse:
    """
    获取登录验证码

    参数:
    - redis (Redis): Redis客户端对象

    返回:
    - CaptchaOutSchema: 包含验证码图片和key的响应模型

    异常:
    - CustomException: 获取验证码失败时抛出异常。
    """
    # 获取验证码
    captcha = await CaptchaService.get_captcha_service(redis=redis)
    log.info("获取验证码成功")
    return SuccessResponse(data=captcha, msg="获取验证码成功")


@AuthRouter.get(
    "/sm-public-key",
    summary="获取SM2公钥",
    description="获取SM2公钥（用于前端加密密码），仅在启用国密加密时有效",
)
async def get_sm2_public_key_controller() -> JSONResponse:
    """
    获取SM2公钥

    返回:
    - JSONResponse: 包含SM2公钥的响应

    异常:
    - CustomException: 未启用国密时抛出。
    """
    return SuccessResponse(
        data={"public_key": settings.SM2_PUBLIC_KEY},
        msg="获取成功",
    )


@AuthRouter.post(
    "/logout",
    summary="退出登录",
    description="退出登录",
    dependencies=[Depends(get_current_user)],
)
async def logout_controller(
    redis: Annotated[Redis, Depends(redis_getter)],
    token: Annotated[str, Depends(OAuth2Schema)],
) -> JSONResponse:
    """
    退出登录

    参数:
    - redis (Redis): Redis客户端对象
    - token (str): 从 Authorization header 提取的访问令牌

    返回:
    - JSONResponse: 包含退出登录结果的响应模型

    异常:
    - CustomException: 退出登录失败时抛出异常。
    """
    if await LoginService.logout_service(redis=redis, token=token):
        log.info("退出成功")
        return SuccessResponse(msg="退出成功")
    return ErrorResponse(msg="退出失败")


@AuthRouter.get(
    "/auto-login/users",
    summary="获取免登录用户列表",
    description="获取可用于免登录快速登录的用户列表",
    response_model=list[AutoLoginUserSchema],
)
async def get_auto_login_users_controller(
    db: Annotated[AsyncSession, Depends(db_getter)],
) -> JSONResponse:
    """
    获取免登录用户列表

    参数:
    - db (AsyncSession): 数据库会话对象

    返回:
    - list[AutoLoginUserSchema]: 免登录用户列表
    """
    users = await AutoLoginService.get_auto_login_users_service(db=db)
    return SuccessResponse(data=users, msg="获取成功")


@AuthRouter.post(
    "/auto-login/token",
    summary="获取免登录Token",
    description="根据用户ID生成免登录Token",
    response_model=AutoLoginTokenSchema,
)
async def get_auto_login_token_controller(
    redis: Annotated[Redis, Depends(redis_getter)],
    db: Annotated[AsyncSession, Depends(db_getter)],
    user_id: int,
) -> JSONResponse:
    """
    获取免登录Token

    参数:
    - redis (Redis): Redis客户端对象
    - db (AsyncSession): 数据库会话对象
    - user_id (int): 用户ID

    返回:
    - AutoLoginTokenSchema: 免登录Token和用户信息
    """
    result = await AutoLoginService.create_auto_login_token_service(
        redis=redis, db=db, user_id=user_id
    )
    return SuccessResponse(data=result, msg="获取成功")


@AuthRouter.post(
    "/auto-login",
    summary="免登录",
    description="使用免登录Token快速登录",
    response_model=JWTOutSchema,
)
async def auto_login_controller(
    request: Request,
    redis: Annotated[Redis, Depends(redis_getter)],
    db: Annotated[AsyncSession, Depends(db_getter)],
    token: str,
) -> JSONResponse:
    """
    免登录

    参数:
    - request (Request): FastAPI请求对象
    - redis (Redis): Redis客户端对象
    - db (AsyncSession): 数据库会话对象
    - token (str): 免登录Token

    返回:
    - JWTOutSchema: JWT令牌信息
    """
    login_token = await AutoLoginService.auto_login_service(
        request=request, redis=redis, db=db, token=token
    )
    log.info("用户免登录成功")
    return SuccessResponse(data=login_token.model_dump(), msg="登录成功")


@AuthRouter.get(
    "/oauth/{provider}/login",
    summary="第三方OAuth跳转",
    description="浏览器重定向到微信/GitHub/Gitee/QQ 授权页；redirect_uri 为授权完成后回到前端的登录页地址（如 http://localhost:5173/login）。",
)
async def oauth_login_redirect_controller(
    request: Request,
    redis: Annotated[Redis, Depends(redis_getter)],
    provider: Annotated[OAuthProvider, Path(description="wechat | qq | github | gitee")],
    redirect_uri: Annotated[
        str | None,
        Query(description="OAuth 完成后浏览器回到的前端登录页完整 URL"),
    ] = None,
) -> RedirectResponse:
    allowed = {"wechat", "qq", "github", "gitee"}
    fe = redirect_uri or settings.OAUTH_FRONTEND_FALLBACK
    if provider not in allowed:
        return RedirectResponse(
            url=oauth_service_error_redirect(fe, "不支持的 OAuth 渠道"),
            status_code=302,
        )
    if not redirect_uri:
        return RedirectResponse(
            url=oauth_service_error_redirect(fe, "缺少 redirect_uri 参数"),
            status_code=302,
        )
    try:
        state = secrets.token_urlsafe(32)
        await save_oauth_state(
            redis=redis,
            state=state,
            provider=provider,
            frontend_redirect=redirect_uri,
        )
        cb = _callback_url(request, provider)
        url = build_authorize_url(provider=provider, callback_url=cb, state=state)
        return RedirectResponse(url=url, status_code=302)
    except CustomException as e:
        return RedirectResponse(
            url=oauth_service_error_redirect(redirect_uri, e.msg),
            status_code=302,
        )


@AuthRouter.get(
    "/oauth/{provider}/callback",
    summary="第三方OAuth回调",
    include_in_schema=False,
)
async def oauth_callback_controller(
    request: Request,
    redis: Annotated[Redis, Depends(redis_getter)],
    db: Annotated[AsyncSession, Depends(db_getter)],
    provider: Annotated[OAuthProvider, Path()],
    code: Annotated[str | None, Query()] = None,
    state: Annotated[str | None, Query()] = None,
) -> RedirectResponse:
    fe_fallback = settings.OAUTH_FRONTEND_FALLBACK

    async def resolve_frontend() -> str:
        if not state:
            return fe_fallback
        raw = await RedisCURD(redis).get(f"{STATE_PREFIX}{state}")
        if not raw:
            return fe_fallback
        if isinstance(raw, bytes):
            raw = raw.decode("utf-8")
        try:
            payload = json.loads(raw)
            return str(payload.get("frontend_redirect") or fe_fallback).strip() or fe_fallback
        except json.JSONDecodeError:
            return fe_fallback

    if provider not in {"wechat", "qq", "github", "gitee"}:
        url = oauth_service_error_redirect(await resolve_frontend(), "不支持的 OAuth 渠道")
        return RedirectResponse(url=url, status_code=302)
    if not code or not state:
        url = oauth_service_error_redirect(
            await resolve_frontend(), "授权被取消或参数不完整"
        )
        return RedirectResponse(url=url, status_code=302)
    try:
        token, fe = await complete_oauth_login(
            request=request,
            redis=redis,
            db=db,
            provider=provider,
            code=code,
            state=state,
        )
        success_url = oauth_service_frontend_redirect_from_token(fe, token)
        return RedirectResponse(url=success_url, status_code=302)
    except CustomException as e:
        fe = await resolve_frontend()
        return RedirectResponse(url=oauth_service_error_redirect(fe, e.msg), status_code=302)
