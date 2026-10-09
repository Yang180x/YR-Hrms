"""日志归属地异步回填（sink PENDING → ``_fill_login_location``）单测。

上游 11160b05 用 FastAPI BackgroundTasks 回填登录日志行；我方等价载体是
log 模块 sink 写行后的 ``asyncio.create_task``。本测试守卫该回填分支：
解析成功 → UPDATE 行；解析仍为 PENDING / IP 为空 → 不动行。
"""

from __future__ import annotations

import asyncio

import pytest
from starlette.testclient import TestClient

from app.core.database import async_db_session
from app.plugin.module_system.log.model import OperationLogModel
from app.plugin.module_system.log.service import _fill_login_location
from app.utils.ip_local_util import LOCATION_PENDING, IpLocalUtil


class TestFillLoginLocation:
    """``_fill_login_location`` 行为守卫。"""

    def test_updates_pending_row(
        self, test_client: TestClient, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        """解析成功时应把 PENDING 行 UPDATE 为真实归属地。"""
        _ = test_client  # 确保应用 lifespan 已初始化（建表）

        async def fake_resolve(redis: object, ip: str | None) -> str:
            return "中国-测试市"

        monkeypatch.setattr(IpLocalUtil, "resolve_location_async", fake_resolve)

        async def scenario() -> None:
            async with async_db_session() as session:
                async with session.begin():
                    row = OperationLogModel(
                        type=1,
                        request_path="/api/v1/system/auth/login",
                        request_method="POST",
                        response_code=200,
                        request_ip="203.0.113.9",
                        login_location=LOCATION_PENDING,
                    )
                    session.add(row)
                    await session.flush()
                    row_id = row.id

            await _fill_login_location(None, row_id, "203.0.113.9")

            async with async_db_session() as session:
                saved = await session.get(OperationLogModel, row_id)
                assert saved is not None
                assert saved.login_location == "中国-测试市"

        asyncio.run(scenario())

    def test_keeps_row_when_resolve_still_pending(
        self, test_client: TestClient, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        """解析结果仍为 PENDING 时不应 UPDATE（避免无意义写）。"""
        _ = test_client

        async def fake_resolve(redis: object, ip: str | None) -> str:
            return LOCATION_PENDING

        monkeypatch.setattr(IpLocalUtil, "resolve_location_async", fake_resolve)

        async def scenario() -> None:
            async with async_db_session() as session:
                async with session.begin():
                    row = OperationLogModel(
                        type=1,
                        request_path="/api/v1/system/auth/login",
                        request_method="POST",
                        response_code=200,
                        request_ip="203.0.113.10",
                        login_location=LOCATION_PENDING,
                    )
                    session.add(row)
                    await session.flush()
                    row_id = row.id

            await _fill_login_location(None, row_id, "203.0.113.10")

            async with async_db_session() as session:
                saved = await session.get(OperationLogModel, row_id)
                assert saved is not None
                assert saved.login_location == LOCATION_PENDING

        asyncio.run(scenario())

    def test_noop_without_ip(self, test_client: TestClient) -> None:
        """IP 为空应直接返回（不应抛错、不触库）。"""
        _ = test_client
        asyncio.run(_fill_login_location(None, 999_999_999, None))
