"""versions / ticket 模块单元测试。

覆盖：版本状态校验、工单状态机全矩阵（转换合法性 × 角色守卫）、
TicketTypeEnum 取值、菜单种子结构（System 末尾追加 + 自然键唯一 + 权限齐全）、
模型列类型（Integer status 覆盖 mixin String）。
"""

from __future__ import annotations

import json
from pathlib import Path
from types import SimpleNamespace

import pytest
from pydantic import ValidationError
from sqlalchemy import Integer

from app.common.enums import TicketTypeEnum
from app.core.exceptions import CustomException
from app.plugin.module_system.ticket.model import (
    TicketCommentModel,
    TicketModel,
)
from app.plugin.module_system.ticket.schema import (
    TicketBatchSchema,
)
from app.plugin.module_system.ticket.service import (
    TICKET_STATUS_LABELS,
    TICKET_STATUS_TRANSITIONS,
    validate_status_transition,
)
from app.plugin.module_system.versions.model import VersionModel
from app.plugin.module_system.versions.schema import VersionStatusSchema

MENU_SEED = (
    Path(__file__).resolve().parents[1]
    / "app/plugin/module_system/seeds/data/sys_menu.json"
)


# ─── 版本状态校验 ───────────────────────────────────────────────


class TestVersionStatusSchema:
    """VersionStatusSchema：仅允许 0/1/2。"""

    @pytest.mark.parametrize("value", [0, 1, 2])
    def test_valid_status(self, value: int) -> None:
        """0/1/2 合法。"""
        assert VersionStatusSchema(status=value).status == value

    @pytest.mark.parametrize("value", [-1, 3, 99])
    def test_invalid_status(self, value: int) -> None:
        """-1/3/99 非法，pydantic 抛 ValidationError。"""
        with pytest.raises(ValidationError):
            VersionStatusSchema(status=value)


# ─── 工单状态机：全转换矩阵 ─────────────────────────────────────

SUPER = SimpleNamespace(id=1, is_superuser=True)
CREATOR = SimpleNamespace(id=2, is_superuser=False)
ASSIGNEE = SimpleNamespace(id=3, is_superuser=False)
STRANGER = SimpleNamespace(id=4, is_superuser=False)


def ticket(status: int, created_id: int = 2, assigned_id: int | None = 3):
    """构造工单实体替身。"""
    return SimpleNamespace(
        status=status, created_id=created_id, assigned_id=assigned_id
    )


# (旧状态, 新状态, 用户, 应通过?)
LEGAL_CASES = [
    # 超管可执行全部合法转换
    (0, 1, SUPER, True),
    (0, 3, SUPER, True),
    (1, 2, SUPER, True),
    (1, 3, SUPER, True),
    (2, 3, SUPER, True),
    (3, 0, SUPER, True),
    # 创建人：受理 / 取消 / 关闭(1→3,2→3)
    (0, 1, CREATOR, True),
    (0, 3, CREATOR, True),
    (1, 3, CREATOR, True),
    (2, 3, CREATOR, True),
    # 处理人：受理 / 完成 / 关闭
    (0, 1, ASSIGNEE, True),
    (1, 2, ASSIGNEE, True),
    (1, 3, ASSIGNEE, True),
    # 路人：任何转换都无权（除转换本身非法外，守卫全部拦截）
    (0, 1, STRANGER, False),
    (0, 3, STRANGER, False),
    (1, 2, STRANGER, False),
    (1, 3, STRANGER, False),
    (2, 3, STRANGER, False),
    (3, 0, STRANGER, False),
    # 重开（3→0）仅超管：创建人也不行
    (3, 0, CREATOR, False),
    (3, 0, ASSIGNEE, False),
    # 完成（1→2）创建人不行（非处理人）
    (1, 2, CREATOR, False),
]


class TestTicketStatusStateMachine:
    """validate_status_transition：合法转换 × 角色守卫。"""

    @pytest.mark.parametrize("old,new,user,allowed", LEGAL_CASES)
    def test_transition_matrix(
        self, old: int, new: int, user: SimpleNamespace, allowed: bool
    ) -> None:
        """全矩阵：按角色断言放行或抛 400 业务异常。"""
        t = ticket(old)
        if allowed:
            validate_status_transition(t, new, user)
        else:
            with pytest.raises(CustomException):
                validate_status_transition(t, new, user)

    @pytest.mark.parametrize(
        "old,new",
        [(0, 0), (0, 2), (1, 0), (1, 1), (2, 0), (2, 1), (2, 2), (3, 1), (3, 2), (3, 3)],
    )
    def test_illegal_transitions_rejected_even_for_super(
        self, old: int, new: int
    ) -> None:
        """非法转换对超管也拒绝（状态机先于角色守卫）。"""
        with pytest.raises(CustomException, match="不允许从"):
            validate_status_transition(ticket(old), new, SUPER)

    def test_anonymous_user_rejected(self) -> None:
        """user=None（无用户上下文）不享有任何特权。"""
        with pytest.raises(CustomException):
            validate_status_transition(ticket(3), 0, None)

    def test_transition_tables_consistent(self) -> None:
        """转换表与标签表覆盖 0-3 全部状态。"""
        assert set(TICKET_STATUS_TRANSITIONS) == {0, 1, 2, 3}
        assert set(TICKET_STATUS_LABELS) == {0, 1, 2, 3}
        # 3（已关闭）只能流向 0（重开）
        assert TICKET_STATUS_TRANSITIONS[3] == {0}


# ─── 枚举 ───────────────────────────────────────────────────────


class TestTicketTypeEnum:
    """TicketTypeEnum 四个取值与上游字符串契约一致。"""

    def test_values(self) -> None:
        """取值锁定 suggestion/bug/optimize/other。"""
        assert {t.value for t in TicketTypeEnum} == {
            "suggestion",
            "bug",
            "optimize",
            "other",
        }

    def test_str_enum_usable_as_str(self) -> None:
        """str-Enum 可直接当字符串比较（前端按字符串消费）。"""
        assert TicketTypeEnum.BUG == "bug"


# ─── 模型列 ─────────────────────────────────────────────────────


class TestModelColumns:
    """status 覆盖 mixin 的关键列断言（防回归为 String）。"""

    def test_version_status_is_integer(self) -> None:
        """sys_version.status 必须是 Integer（覆盖 mixin String(10)）。"""
        col = VersionModel.__table__.columns["status"]
        assert isinstance(col.type, Integer)

    def test_version_unique_constraint(self) -> None:
        """version 列有唯一约束。"""
        assert VersionModel.__table__.c.version.unique is True

    def test_ticket_status_is_integer(self) -> None:
        """sys_ticket.status 必须是 Integer。"""
        col = TicketModel.__table__.columns["status"]
        assert isinstance(col.type, Integer)

    def test_ticket_comment_fk(self) -> None:
        """sys_ticket_comment.ticket_id 外键指向 sys_ticket。"""
        col = TicketCommentModel.__table__.columns["ticket_id"]
        assert col.foreign_keys
        assert next(iter(col.foreign_keys)).target_fullname == "sys_ticket.id"

    def test_ticket_assigned_relation_selectin(self) -> None:
        """assigned_by 关系为 selectin（async 下防 MissingGreenlet）。"""
        rel = TicketModel.__mapper__.relationships["assigned_by"]
        assert rel.lazy == "selectin"


# ─── 菜单种子 ───────────────────────────────────────────────────


class TestMenuSeed:
    """sys_menu.json：System 末尾追加 + 自然键唯一 + 权限齐全。"""

    @pytest.fixture(scope="class")
    def tree(self) -> list[dict]:
        """加载菜单种子树。"""
        return json.loads(MENU_SEED.read_text(encoding="utf-8"))

    @staticmethod
    def _find(nodes: list[dict], route_name: str) -> dict | None:
        """按 route_name 递归查找节点。"""
        for n in nodes:
            if n.get("route_name") == route_name:
                return n
            hit = TestMenuSeed._find(n.get("children") or [], route_name)
            if hit:
                return hit
        return None

    def test_system_children_appended_at_end(self, tree: list[dict]) -> None:
        """工单(order=8)/版本(order=9) 追加在 System children 末尾且 order 连续。"""
        system = self._find(tree, "System")
        assert system is not None
        children = system["children"]
        orders = [c["order"] for c in children]
        assert orders == sorted(orders), "children order 必须升序"
        assert children[-2]["name"] == "工单管理" and children[-2]["order"] == 8
        assert children[-1]["name"] == "版本管理" and children[-1]["order"] == 9

    def test_new_menu_natural_keys_unique(self, tree: list[dict]) -> None:
        """全树 (route_path, name) 自然键唯一（种子 applier 幂等键）。"""
        keys: list[tuple[str, str]] = []

        def collect(nodes: list[dict]) -> None:
            for n in nodes:
                keys.append((str(n.get("route_path")), str(n.get("name"))))
                collect(n.get("children") or [])

        collect(tree)
        assert len(keys) == len(set(keys)), "存在重复自然键，种子会静默丢行"

    def test_required_permissions_present(self, tree: list[dict]) -> None:
        """两模块全部权限串在种子中齐备。"""
        perms: set[str] = set()

        def collect(nodes: list[dict]) -> None:
            for n in nodes:
                if n.get("permission"):
                    perms.add(n["permission"])
                collect(n.get("children") or [])

        collect(tree)
        need = {
            "module_system:ticket:query", "module_system:ticket:create",
            "module_system:ticket:update", "module_system:ticket:delete",
            "module_system:ticket:detail", "module_system:ticket:export",
            "module_system:version:query", "module_system:version:create",
            "module_system:version:update", "module_system:version:delete",
            "module_system:version:detail",
        }
        assert need <= perms, f"缺少权限: {sorted(need - perms)}"

    def test_component_paths(self, tree: list[dict]) -> None:
        """component_path 指向待移植的 Web 页面路径。"""
        ticket = self._find(tree, "Ticket")
        version = self._find(tree, "Version")
        assert ticket is not None and ticket["route_path"] == "/system/ticket"
        assert ticket["component_path"] == "module_system/ticket/index"
        assert version is not None and version["route_path"] == "/system/version"
        assert version["component_path"] == "module_system/version/index"

    def test_button_status_is_string_zero(self, tree: list[dict]) -> None:
        """我方种子 status 用字符串 \"0\"（上游是 int，不能照抄）。"""
        for name in ("Ticket", "Version"):
            node = self._find(tree, name)
            assert node is not None
            assert node["status"] == "0"
            for b in node["children"]:
                assert b["status"] == "0"


# ─── 批量 schema 边界 ──────────────────────────────────────────


class TestTicketBatchSchema:
    """TicketBatchSchema：ids 不能为空、status 限 0-3。"""

    def test_empty_ids_rejected(self) -> None:
        """空 ids 被 pydantic 拒绝。"""
        with pytest.raises(ValidationError):
            TicketBatchSchema(ids=[], status=1)

    def test_status_out_of_range_rejected(self) -> None:
        """status=4 被拒绝。"""
        with pytest.raises(ValidationError):
            TicketBatchSchema(ids=[1], status=4)

    def test_valid(self) -> None:
        """正常入参通过。"""
        s = TicketBatchSchema(ids=[1, 2], status=3)
        assert s.ids == [1, 2] and s.status == 3
