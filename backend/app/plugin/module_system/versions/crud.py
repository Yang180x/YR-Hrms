from collections.abc import Sequence
from typing import Any

from app.core.auth.schema import AuthSchema
from app.core.base_crud import CRUDBase

from .model import VersionModel
from .schema import VersionCreateSchema, VersionUpdateSchema


class VersionCRUD(CRUDBase[VersionModel, VersionCreateSchema, VersionUpdateSchema]):
    """版本数据层"""

    def __init__(self, auth: AuthSchema) -> None:
        """
        初始化版本数据层。

        参数:
        - auth (AuthSchema): 认证信息模型（含 DB 会话等上下文）。

        返回:
        - None
        """
        self.auth = auth
        super().__init__(model=VersionModel, auth=auth)

    async def get_by_id_crud(
        self, id: int, preload: list[str | Any] | None = None
    ) -> VersionModel | None:
        """
        根据ID获取版本。

        参数:
        - id (int): 版本ID。
        - preload (list | None): 预加载关系，未提供时使用模型默认项。

        返回:
        - VersionModel | None: 版本模型实例，不存在返回 None。
        """
        return await self.get(id=id, preload=preload)

    async def get_list_crud(
        self,
        search: dict | None = None,
        order_by: list[dict[str, str]] | None = None,
        preload: list[str | Any] | None = None,
    ) -> Sequence[VersionModel]:
        """
        获取版本列表。

        参数:
        - search (dict | None): 查询参数。
        - order_by (list[dict[str, str]] | None): 排序参数。
        - preload (list | None): 预加载关系，未提供时使用模型默认项。

        返回:
        - Sequence[VersionModel]: 版本模型实例列表。
        """
        return await self.list(search=search, order_by=order_by, preload=preload)

    async def create_crud(self, data: VersionCreateSchema) -> VersionModel:
        """
        创建版本。

        参数:
        - data (VersionCreateSchema): 版本创建模型。

        返回:
        - VersionModel: 新创建的版本模型实例。
        """
        return await self.create(data=data)

    async def update_crud(
        self, id: int, data: VersionUpdateSchema | dict[str, Any]
    ) -> VersionModel:
        """
        更新版本。

        参数:
        - id (int): 版本ID。
        - data (VersionUpdateSchema | dict): 版本更新模型或字段字典。

        返回:
        - VersionModel: 更新后的版本模型实例。

        异常:
        - CustomException: 版本不存在或无权限访问。
        """
        return await self.update(id=id, data=data)

    async def delete_crud(self, ids: list[int]) -> None:
        """
        删除版本（软删除）。

        参数:
        - ids (list[int]): 版本ID列表。

        返回:
        - None
        """
        await self.delete(ids=ids)
