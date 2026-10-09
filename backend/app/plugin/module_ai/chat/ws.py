import asyncio
import json

from fastapi import APIRouter, WebSocket

from app.core.auth.permission import AuthPermission
from app.core.auth.schema import AuthSchema
from app.core.database import async_db_session
from app.core.dependencies import _verify_token
from app.core.exceptions import CustomException
from app.core.logger import log
from app.core.router_class import OperationLogRoute

from .schema import ChatQuerySchema
from .service import ChatService

WS_AI = APIRouter(
    route_class=OperationLogRoute,
    prefix="/ai/chat",
    tags=["智能助手WebSocket"],
)


async def _check_ws_chat_permission(auth: AuthSchema) -> None:
    """校验 WebSocket 用户的 AI 聊天权限（菜单「AI智能助手/AI对话」按钮）。

    WS 握手只验 token 会让无权限用户绕过菜单权限直接对话——这里复用内核
    ``AuthPermission``（超管/通配直接放行，否则按角色菜单权限求交集）。
    权限串用菜单种子中 WS 专属的 ``module_ai:chat:ws``（「AI对话」按钮），
    HTTP ``/ai-chat`` 端点仍用 ``module_ai:chat:query``。拒绝时抛 403。

    参数:
    - auth (AuthSchema): `_verify_token` 返回的认证上下文。

    返回:
    - None

    异常:
    - CustomException: 用户不具备 AI 聊天（WS）权限（403）。
    """
    await AuthPermission(["module_ai:chat:ws"])(auth)


@WS_AI.websocket("/ws", name="WebSocket聊天")
async def websocket_chat_controller(
    websocket: WebSocket,
) -> None:
    """
    WebSocket 聊天接口。

    参数:
    - websocket (WebSocket): WebSocket 连接。

    返回:
    - None: 长连接处理完毕或关闭后无返回值。

    支持两种消息格式：
    1. 纯文本：直接发送消息内容
    2. JSON 格式：{"message": "消息内容", "session_id": "会话ID", "files": [...]}

    ws://127.0.0.1:8001/api/v1/ai/chat/ws?token=xxx
    """
    await websocket.accept()

    # 从查询参数获取token并认证
    token = websocket.query_params.get("token")
    if token:
        try:
            # 获取数据库和redis连接
            async with async_db_session() as db:
                redis = websocket.app.state.redis
                auth = await _verify_token(token, db, redis)

                # 权限校验：菜单「AI对话」按钮（module_ai:chat:ws），
                # 无权限用户拒绝对话并关闭连接
                try:
                    await _check_ws_chat_permission(auth)
                except CustomException as e:
                    log.warning(
                        f"WebSocket权限不足: {websocket.client} - {e.msg}"
                    )
                    try:
                        await websocket.send_text(f"错误: {e.msg}")
                    except RuntimeError:
                        log.warning("WebSocket连接已关闭，无法发送权限错误")
                    finally:
                        try:
                            await websocket.close()
                        except RuntimeError:
                            pass
                    return

                user_info = f"用户: {auth.user.username}" if auth and auth.user else "未认证用户"
                log.info(f"WebSocket连接已建立: {websocket.client} - {user_info}")

                # 保存用户信息到websocket状态
                websocket.state.auth = auth

                # 进入消息循环（60s 空闲超时：防客户端崩溃后连接悬挂，文章 v4 服务端配套）
                while True:
                    try:
                        data = await asyncio.wait_for(websocket.receive_text(), timeout=60.0)
                    except TimeoutError:
                        log.info(f"WebSocket空闲超时60s，服务端主动关闭: {websocket.client}")
                        await websocket.close()
                        return
                    # 心跳：客户端 ping（文本或 JSON）→ 回 pong；不进入业务校验
                    if data == "ping":
                        await websocket.send_text(json.dumps({"type": "pong"}))
                        continue
                    try:
                        message_data = json.loads(data)
                        if isinstance(message_data, dict) and message_data.get("type") == "ping":
                            await websocket.send_text(json.dumps({"type": "pong"}))
                            continue
                        query = ChatQuerySchema(**message_data)
                        log.info(f"收到聊天查询: {query}- 会话ID: {query.session_id}")

                        # 处理AI回复（使用 agno 记忆存储）
                        chat_result = ChatService.chat_query(query=query, auth=auth)
                        async for chunk in chat_result:
                            if chunk:
                                try:
                                    await websocket.send_text(chunk)
                                except RuntimeError:
                                    log.warning("WebSocket连接已关闭，停止发送消息")
                                    break
                    except json.JSONDecodeError:
                        log.warning(f"收到非JSON消息: {data}")
                        try:
                            await websocket.send_text("消息格式错误，请发送JSON格式的消息")
                        except RuntimeError:
                            log.warning("WebSocket连接已关闭，无法发送错误消息")
                            break
                    except Exception as e:
                        log.error(f"处理消息时出错: {e}")
                        try:
                            await websocket.send_text(f"处理消息时出错: {e!s}")
                        except RuntimeError:
                            log.warning("WebSocket连接已关闭，无法发送错误消息")
                            break
        except Exception as e:
            log.warning(f"WebSocket认证失败或聊天出错: {e}")
            try:
                await websocket.send_text(f"错误: {e!s}")
            except RuntimeError:
                log.warning("WebSocket连接已关闭，无法发送错误消息")
            finally:
                try:
                    await websocket.close()
                except RuntimeError:
                    pass
            return
    else:
        log.warning(f"WebSocket连接未提供token: {websocket.client}")
        try:
            await websocket.send_text("未提供认证token，请重新登录")
        except RuntimeError:
            log.warning("WebSocket连接已关闭，无法发送错误消息")
        finally:
            try:
                await websocket.close()
            except RuntimeError:
                pass
        return
