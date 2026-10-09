from collections.abc import Sequence
from typing import Any

from app.core.auth.schema import AuthSchema
from app.core.base_crud import CRUDBase

from .model import TicketCommentModel, TicketModel
from .schema import (
    TicketCommentCreateSchema,
    TicketCreateSchema,
    TicketUpdateSchema,
)


class TicketCRUD(CRUDBase[TicketModel, TicketCreateSchema, TicketUpdateSchema]):
    """工单数据层"""

    def __init__(self, auth: AuthSchema) -> None:
        """
        初始化工单数据层。

        参数:
        - auth (AuthSchema): 认证信息模型（含 DB 会话等上下文）。

        返回:
        - None
        """
        self.auth = auth
        super().__init__(model=TicketModel, auth=auth)

    async def get_by_id_crud(self, id: int) -> TicketModel | None:
        """
        根据ID获取工单（模型默认 preload 含 assigned_by）。

        参数:
        - id (int): 工单ID。

        返回:
        - TicketModel | None: 工单模型实例，不存在返回 None。
        """
        return await self.get(id=id)

    async def get_list_crud(
        self,
        search: dict | None = None,
        order_by: list[dict[str, str]] | None = None,
        preload: list[str | Any] | None = None,
    ) -> Sequence[TicketModel]:
        """
        获取工单列表。

        参数:
        - search (dict | None): 查询参数。
        - order_by (list[dict[str, str]] | None): 排序参数。
        - preload (list | None): 预加载关系，未提供时使用模型默认项。

        返回:
        - Sequence[TicketModel]: 工单模型实例列表。
        """
        return await self.list(search=search, order_by=order_by, preload=preload)

    async def create_crud(self, data: TicketCreateSchema) -> TicketModel:
        """
        创建工单。

        参数:
        - data (TicketCreateSchema): 工单创建模型。

        返回:
        - TicketModel: 新创建的工单模型实例。
        """
        return await self.create(data=data)

    async def update_crud(
        self, id: int, data: TicketUpdateSchema | dict[str, Any]
    ) -> TicketModel:
        """
        更新工单。

        参数:
        - id (int): 工单ID。
        - data (TicketUpdateSchema | dict): 工单更新模型或字段字典。

        返回:
        - TicketModel: 更新后的工单模型实例。

        异常:
        - CustomException: 工单不存在或无权限访问。
        """
        return await self.update(id=id, data=data)

    async def delete_crud(self, ids: list[int]) -> None:
        """
        删除工单（软删除）。

        参数:
        - ids (list[int]): 工单ID列表。

        返回:
        - None
        """
        await self.delete(ids=ids)

    async def set_crud(self, ids: list[int], **kwargs: Any) -> None:
        """
        批量更新工单字段（批量状态流转用）。

        参数:
        - ids (list[int]): 工单ID列表。
        - **kwargs: 待更新的字段值。

        返回:
        - None
        """
        await self.set(ids=ids, **kwargs)


class TicketCommentCRUD(
    CRUDBase[TicketCommentModel, TicketCommentCreateSchema, Any]
):
    """工单评论数据层"""

    def __init__(self, auth: AuthSchema) -> None:
        """
        初始化工单评论数据层。

        参数:
        - auth (AuthSchema): 认证信息模型（含 DB 会话等上下文）。

        返回:
        - None
        """
        self.auth = auth
        super().__init__(model=TicketCommentModel, auth=auth)

    async def create_comment_crud(self, data: dict[str, Any]) -> TicketCommentModel:
        """
        创建工单评论。

        参数:
        - data (dict): 评论字段字典（含 ticket_id）。

        返回:
        - TicketCommentModel: 新创建的评论模型实例。
        """
        return await self.create(data=data)
