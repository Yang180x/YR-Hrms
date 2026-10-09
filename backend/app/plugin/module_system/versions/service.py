from app.core.auth.schema import AuthSchema
from app.core.exceptions import CustomException

from .crud import VersionCRUD
from .schema import (
    VersionCreateSchema,
    VersionOutSchema,
    VersionQueryParam,
    VersionStatusSchema,
    VersionUpdateSchema,
)


class VersionService:
    """版本管理模块服务层"""

    @classmethod
    async def get_version_page_service(
        cls,
        auth: AuthSchema,
        page_no: int,
        page_size: int,
        search: VersionQueryParam | None = None,
        order_by: list[dict[str, str]] | None = None,
    ) -> dict:
        """
        分页查询版本（默认 sort 升序、id 降序）。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - page_no (int): 页码（从 1 开始）。
        - page_size (int): 每页条数。
        - search (VersionQueryParam | None): 查询条件。
        - order_by (list[dict[str, str]] | None): 排序字段列表。

        返回:
        - dict: 分页结果（结构由 `CRUD.page` 返回约定）。
        """
        offset = (page_no - 1) * page_size
        return await VersionCRUD(auth).page(
            offset=offset,
            limit=page_size,
            order_by=order_by or [{"sort": "asc"}, {"id": "desc"}],
            search=search.__dict__ if search else {},
            out_schema=VersionOutSchema,
        )

    @classmethod
    async def get_version_detail_service(cls, auth: AuthSchema, id: int) -> dict:
        """
        获取版本详情。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - id (int): 版本ID。

        返回:
        - dict: 版本详情字典。

        异常:
        - CustomException: 该数据不存在。

        """
        obj = await VersionCRUD(auth).get_by_id_crud(id=id)
        if not obj:
            raise CustomException(msg="该数据不存在")
        return VersionOutSchema.model_validate(obj).model_dump()

    @classmethod
    async def create_version_service(
        cls, auth: AuthSchema, data: VersionCreateSchema
    ) -> dict:
        """
        创建版本（version 列有唯一约束，重复由 DB 兜底）。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - data (VersionCreateSchema): 版本创建负载模型。

        返回:
        - dict: 新建版本详情字典。
        """
        obj = await VersionCRUD(auth).create_crud(data=data)
        return VersionOutSchema.model_validate(obj).model_dump()

    @classmethod
    async def update_version_service(
        cls, auth: AuthSchema, id: int, data: VersionUpdateSchema
    ) -> dict:
        """
        更新版本。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - id (int): 版本ID。
        - data (VersionUpdateSchema): 版本更新负载模型。

        返回:
        - dict: 更新后的版本详情字典。

        异常:
        - CustomException: 更新失败，该数据不存在。
        """
        obj = await VersionCRUD(auth).get_by_id_crud(id=id)
        if not obj:
            raise CustomException(msg="更新失败，该数据不存在")
        obj = await VersionCRUD(auth).update_crud(id=id, data=data)
        return VersionOutSchema.model_validate(obj).model_dump()

    @classmethod
    async def delete_version_service(cls, auth: AuthSchema, ids: list[int]) -> None:
        """
        批量删除版本，先逐个校验存在性。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - ids (list[int]): 版本ID列表。

        返回:
        - None

        异常:
        - CustomException: 删除失败，删除对象不能为空或该数据不存在。
        """
        if not ids:
            raise CustomException(msg="删除失败，删除对象不能为空")
        objs = await VersionCRUD(auth).get_list_crud(search={"id": ("in", ids)})
        obj_map = {o.id: o for o in objs}
        for id_ in ids:
            if id_ not in obj_map:
                raise CustomException(msg="删除失败，该数据不存在")
        await VersionCRUD(auth).delete_crud(ids=ids)

    @classmethod
    async def set_version_status_service(
        cls, auth: AuthSchema, id: int, data: VersionStatusSchema
    ) -> dict:
        """
        变更版本状态（0=草稿 1=已发布 2=已回滚）。

        参数:
        - auth (AuthSchema): 认证信息模型。
        - id (int): 版本ID。
        - data (VersionStatusSchema): 状态负载模型。

        返回:
        - dict: 变更后的版本详情字典。

        异常:
        - CustomException: 该数据不存在。
        """
        obj = await VersionCRUD(auth).get_by_id_crud(id=id)
        if not obj:
            raise CustomException(msg="该数据不存在")
        obj = await VersionCRUD(auth).update_crud(id=id, data={"status": data.status})
        return VersionOutSchema.model_validate(obj).model_dump()

    @classmethod
    async def get_published_versions_service(cls, auth: AuthSchema) -> list[dict]:
        """
        已发布版本列表（status=1，按 sort 升序）。

        参数:
        - auth (AuthSchema): 认证信息模型（可为无用户的匿名上下文）。

        返回:
        - list[dict]: 已发布版本详情字典列表。
        """
        objs = await VersionCRUD(auth).get_list_crud(
            search={"status": 1},
            order_by=[{"sort": "asc"}],
        )
        return [VersionOutSchema.model_validate(obj).model_dump() for obj in objs]
