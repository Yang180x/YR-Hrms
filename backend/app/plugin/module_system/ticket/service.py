"""工单模块服务层。

状态机守卫 ``validate_status_transition`` 为模块级纯函数（不依赖会话），
便于单元测试覆盖全转换矩阵。
"""

from typing import Any

from app.core.auth.schema import AuthSchema
from app.core.exceptions import CustomException
from app.plugin.module_system.user.crud import UserCRUD
from app.utils.excel_util import ExcelUtil

from .crud import TicketCommentCRUD, TicketCRUD
from .schema import (
    TicketBatchSchema,
    TicketCommentCreateSchema,
    TicketCommentOutSchema,
    TicketCreateSchema,
    TicketOutSchema,
    TicketQueryParam,
    TicketStatsSchema,
    TicketUpdateSchema,
)

TICKET_STATUS_TRANSITIONS: dict[int, set[int]] = {
    0: {1, 3},
    1: {2, 3},
    2: {3},
    3: {0},
}
"""合法状态流转：0待处理→1处理/3关闭，1处理→2完成/3关闭，2完成→3关闭，3关闭→0重开"""

TICKET_STATUS_LABELS: dict[int, str] = {
    0: "待处理",
    1: "处理中",
    2: "已完成",
    3: "已关闭",
}


def validate_status_transition(ticket: Any, new_status: int, user: Any) -> None:
    """校验工单状态流转合法性与操作人角色。

    参数:
    - ticket (Any): 工单实体（需有 status/created_id/assigned_id 属性）。
    - new_status (int): 目标状态 0-3。
    - user (Any): 当前用户（需有 id/is_superuser；None 视为无特权）。

    返回:
    - None

    异常:
    - CustomException: 非法流转或无权限执行该流转。
    """
    old_status = ticket.status if ticket.status is not None else 0
    old_label = TICKET_STATUS_LABELS.get(old_status, str(old_status))
    new_label = TICKET_STATUS_LABELS.get(new_status, str(new_status))

    if new_status not in TICKET_STATUS_TRANSITIONS.get(old_status, set()):
        raise CustomException(msg=f"不允许从{old_label}转换为{new_label}")

    is_super = bool(getattr(user, "is_superuser", False)) if user else False
    user_id = getattr(user, "id", None) if user else None
    is_creator = bool(user_id) and ticket.created_id == user_id
    is_assignee = bool(user_id) and ticket.assigned_id == user_id

    if new_status == 0:
        if not is_super:
            raise CustomException(msg="仅超管可以重新打开已关闭的工单")
    elif old_status == 0 and new_status == 1:
        if not (is_super or is_creator or is_assignee):
            raise CustomException(msg="仅创建人、处理人或超管可以受理工单")
    elif old_status == 0 and new_status == 3:
        if not (is_super or is_creator):
            raise CustomException(msg="仅创建人或超管可以取消工单")
    elif old_status == 1 and new_status == 2:
        if not (is_super or is_assignee):
            raise CustomException(msg="仅处理人或超管可以将工单标记为已完成")
    elif old_status == 1 and new_status == 3:
        if not (is_super or is_creator or is_assignee):
            raise CustomException(msg="仅创建人、处理人或超管可以关闭工单")
    elif old_status == 2 and new_status == 3:
        if not (is_super or is_creator):
            raise CustomException(msg="仅创建人或超管可以确认关闭工单")


class TicketService:
    """工单管理服务"""

    @classmethod
    async def get_ticket_page_service(
        cls,
        auth: AuthSchema,
        page_no: int,
        page_size: int,
        search: TicketQueryParam | None = None,
        order_by: list[dict[str, str]] | None = None,
    ) -> dict:
        """
        分页查询工单（默认创建时间倒序，预加载指派人）。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - page_no (int): 页码（从 1 开始）。
        - page_size (int): 每页条数。
        - search (TicketQueryParam | None): 查询条件。
        - order_by (list[dict[str, str]] | None): 排序字段列表。

        返回:
        - dict: 分页结果（结构由 `CRUD.page` 返回约定）。
        """
        offset = (page_no - 1) * page_size
        return await TicketCRUD(auth).page(
            offset=offset,
            limit=page_size,
            order_by=order_by or [{"created_time": "desc"}],
            search=search.__dict__ if search else {},
            out_schema=TicketOutSchema,
        )

    @classmethod
    async def get_ticket_detail_service(cls, auth: AuthSchema, id: int) -> dict:
        """
        获取工单详情。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - id (int): 工单ID。

        返回:
        - dict: 工单详情字典。
        """
        obj = await TicketCRUD(auth).get_or_404(id=id, msg="工单不存在")
        return TicketOutSchema.model_validate(obj).model_dump()

    @classmethod
    async def create_ticket_service(
        cls, auth: AuthSchema, data: TicketCreateSchema
    ) -> dict:
        """
        创建工单，成功后返回含预加载关系的详情。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - data (TicketCreateSchema): 工单创建负载模型。

        返回:
        - dict: 新建工单详情字典。
        """
        obj = await TicketCRUD(auth).create_crud(data=data)
        return await cls.get_ticket_detail_service(auth=auth, id=obj.id)

    @classmethod
    async def update_ticket_service(
        cls, auth: AuthSchema, id: int, data: TicketUpdateSchema
    ) -> dict:
        """
        更新工单：状态变更过状态机守卫，指派人过存在性校验。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - id (int): 工单ID。
        - data (TicketUpdateSchema): 工单更新负载模型。

        返回:
        - dict: 更新后的工单详情字典。

        异常:
        - CustomException: 工单不存在 / 非法状态流转 / 指派人不存在。
        """
        obj = await TicketCRUD(auth).get_or_404(id=id, msg="工单不存在")

        if data.status is not None:
            validate_status_transition(obj, data.status, auth.user)

        if data.assigned_id is not None:
            # UserCRUD.exists：软删过滤与数据权限由 CRUDBase 统一生效
            if not await UserCRUD(auth).exists(id=data.assigned_id):
                raise CustomException(msg="指定的处理人不存在")

        updated = await TicketCRUD(auth).update_crud(id=id, data=data)
        return await cls.get_ticket_detail_service(auth=auth, id=updated.id)

    @classmethod
    async def delete_ticket_service(cls, auth: AuthSchema, ids: list[int]) -> None:
        """
        删除工单。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - ids (list[int]): 工单ID列表。

        返回:
        - None

        异常:
        - CustomException: 删除对象不能为空。
        """
        if not ids:
            raise CustomException(msg="删除对象不能为空")
        await TicketCRUD(auth).delete_crud(ids=ids)

    @classmethod
    async def batch_update_ticket_service(
        cls, auth: AuthSchema, data: TicketBatchSchema
    ) -> None:
        """
        批量流转工单状态：逐单过状态机守卫后统一更新。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - data (TicketBatchSchema): 批量更新负载模型。

        返回:
        - None

        异常:
        - CustomException: 未选择工单 / 某工单不存在 / 非法状态流转。
        """
        if not data.ids:
            raise CustomException(msg="请选择要操作的工单")

        tickets = await TicketCRUD(auth).get_list_crud(search={"id": ("in", data.ids)})
        ticket_map = {t.id: t for t in tickets}
        for tid in data.ids:
            obj = ticket_map.get(tid)
            if not obj:
                raise CustomException(msg=f"工单[{tid}]不存在")
            validate_status_transition(obj, data.status, auth.user)
        await TicketCRUD(auth).set_crud(ids=data.ids, status=data.status)

    @classmethod
    async def get_ticket_list_service(
        cls,
        auth: AuthSchema,
        search: TicketQueryParam | None = None,
        order_by: list[dict[str, str]] | None = None,
    ) -> list[dict]:
        """
        查询工单列表（导出用）。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - search (TicketQueryParam | None): 查询条件。
        - order_by (list[dict[str, str]] | None): 排序字段列表。

        返回:
        - list[dict]: 工单详情字典列表。
        """
        obj_list = await TicketCRUD(auth).get_list_crud(
            search=search.__dict__ if search else {},
            order_by=order_by or [{"created_time": "desc"}],
        )
        return [TicketOutSchema.model_validate(obj).model_dump() for obj in obj_list]

    @classmethod
    async def get_ticket_stats_service(cls, auth: AuthSchema) -> TicketStatsSchema:
        """
        按状态聚合工单数量（待处理/处理中/已完成，已关闭不计入）。

        同一 AsyncSession 不能并发执行，三次 COUNT 顺序发起。

        参数:
        - auth (AuthSchema): 认证信息模型。

        返回:
        - TicketStatsSchema: 聚合统计结果。
        """
        crud = TicketCRUD(auth)
        return TicketStatsSchema(
            pending=await crud.count(status=0),
            processing=await crud.count(status=1),
            done=await crud.count(status=2),
        )

    @classmethod
    async def export_ticket_list_service(
        cls, ticket_list: list[dict[str, Any]]
    ) -> bytes:
        """
        导出工单列表为 xlsx。

        参数:
        - ticket_list (list[dict[str, Any]]): 工单详情字典列表。

        返回:
        - bytes: Excel 文件字节流。
        """
        mapping_dict = {
            "id": "工单编号",
            "title": "工单标题",
            "ticket_type": "工单类型",
            "summary": "工单摘要",
            "status": "工单状态",
            "description": "备注",
            "created_time": "创建时间",
            "updated_time": "更新时间",
        }
        data: list[dict[str, Any]] = [dict(item) for item in ticket_list]
        status_labels = dict(TICKET_STATUS_LABELS)
        for item in data:
            status_value = item.get("status")
            if isinstance(status_value, int):
                item["status"] = status_labels.get(status_value, status_value)
        return ExcelUtil.export_list2excel(list_data=data, mapping_dict=mapping_dict)


class TicketCommentService:
    """工单评论服务"""

    @classmethod
    async def get_comment_page_service(
        cls,
        auth: AuthSchema,
        ticket_id: int,
        page_no: int,
        page_size: int,
    ) -> dict:
        """
        分页查询某工单的评论（created_by_name 从 created_by 回填）。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - ticket_id (int): 工单ID。
        - page_no (int): 页码（从 1 开始）。
        - page_size (int): 每页条数。

        返回:
        - dict: 分页结果（结构由 `CRUD.page` 返回约定）。
        """
        await TicketCRUD(auth).get_or_404(id=ticket_id, msg="工单不存在")
        result = await TicketCommentCRUD(auth).page(
            offset=(page_no - 1) * page_size,
            limit=page_size,
            order_by=[{"created_time": "desc"}],
            search={"ticket_id": ticket_id},
            out_schema=TicketCommentOutSchema,
        )
        cls._fill_created_by_name(result)
        return result

    @classmethod
    async def create_comment_service(
        cls, auth: AuthSchema, ticket_id: int, data: TicketCommentCreateSchema
    ) -> dict:
        """
        创建工单评论。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - ticket_id (int): 工单ID。
        - data (TicketCommentCreateSchema): 评论内容模型。

        返回:
        - dict: 新建评论详情字典。

        异常:
        - CustomException: 工单不存在 / 评论创建失败。
        """
        await TicketCRUD(auth).get_or_404(id=ticket_id, msg="工单不存在")
        obj = await TicketCommentCRUD(auth).create_comment_crud(
            data=data.model_dump() | {"ticket_id": ticket_id}
        )
        result = TicketCommentOutSchema.model_validate(obj).model_dump()
        created_by = result.get("created_by")
        result["created_by_name"] = created_by.get("name") if created_by else None
        return result

    @classmethod
    def _fill_created_by_name(cls, result: dict) -> None:
        """
        分页结果就地回填 created_by_name（上游 schema 声明但从未填充的字段）。

        参数:
        - result (dict): `CRUD.page` 返回的分页字典。

        返回:
        - None
        """
        for item in result.get("items", []):
            created_by = item.get("created_by")
            item["created_by_name"] = created_by.get("name") if created_by else None
