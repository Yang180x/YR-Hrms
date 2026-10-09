from typing import Annotated

from fastapi import APIRouter, Body, Depends, Path
from fastapi.responses import JSONResponse

from app.common.response import ResponseSchema, SuccessResponse
from app.core.auth.permission import AuthPermission
from app.core.auth.schema import AuthSchema
from app.core.base_params import PaginationQueryParam
from app.core.dependencies import db_getter
from app.core.logger import log
from app.core.router_class import OperationLogRoute

from .schema import (
    VersionCreateSchema,
    VersionOutSchema,
    VersionQueryParam,
    VersionStatusSchema,
    VersionUpdateSchema,
)
from .service import VersionService

VersionRouter = APIRouter(
    route_class=OperationLogRoute, prefix="/versions", tags=["版本管理"]
)


@VersionRouter.get(
    "/list",
    summary="分页查询版本",
    description="分页查询版本",
    response_model=ResponseSchema[list[VersionOutSchema]],
)
async def get_version_list_controller(
    page: Annotated[PaginationQueryParam, Depends()],
    search: Annotated[VersionQueryParam, Depends()],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:version:query"]))],
) -> JSONResponse:
    """
    分页查询版本。

    参数:
    - page (PaginationQueryParam): 分页查询参数模型。
    - search (VersionQueryParam): 查询版本参数模型。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含分页版本详情的响应模型。
    """
    result_dict = await VersionService.get_version_page_service(
        auth=auth,
        page_no=page.page_no,
        page_size=page.page_size,
        search=search,
        order_by=page.order_by,
    )
    log.info("查询版本列表成功")
    return SuccessResponse(data=result_dict, msg="查询版本列表成功")


@VersionRouter.get(
    "/published",
    summary="已发布版本列表",
    description="已发布版本列表（status=1），供更新日志展示",
    response_model=ResponseSchema[list[VersionOutSchema]],
)
async def get_published_versions_controller(
    db=Depends(db_getter),
) -> JSONResponse:
    """
    已发布版本列表。

    匿名可访问（与上游一致）：更新日志属公开信息，匿名上下文 user=None，
    内核数据权限对无用户上下文直接放行。

    参数:
    - db (AsyncSession): 数据库会话（构造匿名认证上下文）。

    返回:
    - JSONResponse: 包含已发布版本列表的响应模型。
    """
    auth = AuthSchema(db=db, check_data_scope=False)
    result = await VersionService.get_published_versions_service(auth=auth)
    log.info("查询已发布版本列表成功")
    return SuccessResponse(data=result, msg="查询成功")


@VersionRouter.get(
    "/detail/{id}",
    summary="获取版本详情",
    description="获取版本详情",
    response_model=ResponseSchema[VersionOutSchema],
)
async def get_version_detail_controller(
    id: Annotated[int, Path(description="版本ID", ge=1)],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:version:detail"]))],
) -> JSONResponse:
    """
    获取版本详情。

    参数:
    - id (int): 版本ID。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含版本详情的响应模型。
    """
    result_dict = await VersionService.get_version_detail_service(auth=auth, id=id)
    log.info(f"获取版本详情成功 {id}")
    return SuccessResponse(data=result_dict, msg="获取版本详情成功")


@VersionRouter.post(
    "/create",
    summary="创建版本",
    description="创建版本",
    response_model=ResponseSchema[VersionOutSchema],
)
async def create_version_controller(
    data: VersionCreateSchema,
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:version:create"]))],
) -> JSONResponse:
    """
    创建版本。

    参数:
    - data (VersionCreateSchema): 创建版本负载模型。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含新建版本详情的响应模型。
    """
    result_dict = await VersionService.create_version_service(auth=auth, data=data)
    log.info(f"创建版本成功: {result_dict.get('version')}")
    return SuccessResponse(data=result_dict, msg="创建版本成功")


@VersionRouter.put(
    "/update/{id}",
    summary="修改版本",
    description="修改版本",
    response_model=ResponseSchema[VersionOutSchema],
)
async def update_version_controller(
    data: VersionUpdateSchema,
    id: Annotated[int, Path(description="版本ID", ge=1)],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:version:update"]))],
) -> JSONResponse:
    """
    修改版本。

    参数:
    - data (VersionUpdateSchema): 修改版本负载模型。
    - id (int): 版本ID。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含修改后版本详情的响应模型。
    """
    result_dict = await VersionService.update_version_service(
        auth=auth, id=id, data=data
    )
    log.info(f"修改版本成功 {id}")
    return SuccessResponse(data=result_dict, msg="修改版本成功")


@VersionRouter.delete(
    "/delete",
    summary="删除版本",
    description="删除版本",
    response_model=ResponseSchema[None],
)
async def delete_version_controller(
    ids: Annotated[list[int], Body(description="ID列表")],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:version:delete"]))],
) -> JSONResponse:
    """
    删除版本。

    参数:
    - ids (list[int]): 版本ID列表。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含删除结果的响应模型。
    """
    await VersionService.delete_version_service(auth=auth, ids=ids)
    log.info(f"删除版本成功: {ids}")
    return SuccessResponse(msg="删除版本成功")


@VersionRouter.put(
    "/{id}/status",
    summary="变更版本状态",
    description="变更版本状态（0=草稿 1=已发布 2=已回滚）",
    response_model=ResponseSchema[VersionOutSchema],
)
async def set_version_status_controller(
    data: VersionStatusSchema,
    id: Annotated[int, Path(description="版本ID", ge=1)],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:version:update"]))],
) -> JSONResponse:
    """
    变更版本状态。

    参数:
    - data (VersionStatusSchema): 状态负载模型。
    - id (int): 版本ID。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含变更后版本详情的响应模型。
    """
    result_dict = await VersionService.set_version_status_service(
        auth=auth, id=id, data=data
    )
    log.info(f"版本状态变更成功 {id} -> {data.status}")
    return SuccessResponse(data=result_dict, msg="状态变更成功")
