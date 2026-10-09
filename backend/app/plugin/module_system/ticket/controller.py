from typing import Annotated

from fastapi import APIRouter, Body, Depends, Path
from fastapi.responses import JSONResponse, StreamingResponse

from app.common.response import ResponseSchema, StreamResponse, SuccessResponse
from app.core.auth.permission import AuthPermission
from app.core.auth.schema import AuthSchema
from app.core.base_params import PaginationQueryParam
from app.core.logger import log
from app.core.router_class import OperationLogRoute
from app.utils.common_util import bytes2file_response

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
from .service import TicketCommentService, TicketService

TicketRouter = APIRouter(
    route_class=OperationLogRoute, prefix="/ticket", tags=["工单管理"]
)


@TicketRouter.get(
    "/stats",
    summary="工单状态统计",
    description="工单状态聚合统计（待处理/处理中/已完成）",
    response_model=ResponseSchema[TicketStatsSchema],
)
async def ticket_stats_controller(
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:ticket:query"]))],
) -> JSONResponse:
    """
    工单状态统计。

    参数:
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含状态聚合统计的响应模型。
    """
    result = await TicketService.get_ticket_stats_service(auth=auth)
    log.info("查询工单状态统计成功")
    return SuccessResponse(data=result, msg="查询成功")


@TicketRouter.get(
    "/list",
    summary="工单列表",
    description="分页查询工单",
    response_model=ResponseSchema[list[TicketOutSchema]],
)
async def ticket_list_controller(
    page: Annotated[PaginationQueryParam, Depends()],
    search: Annotated[TicketQueryParam, Depends()],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:ticket:query"]))],
) -> JSONResponse:
    """
    分页查询工单。

    参数:
    - page (PaginationQueryParam): 分页查询参数模型。
    - search (TicketQueryParam): 查询工单参数模型。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含分页工单详情的响应模型。
    """
    result_dict = await TicketService.get_ticket_page_service(
        auth=auth,
        page_no=page.page_no,
        page_size=page.page_size,
        search=search,
        order_by=page.order_by,
    )
    log.info("查询工单列表成功")
    return SuccessResponse(data=result_dict, msg="查询成功")


@TicketRouter.get(
    "/detail/{id}",
    summary="获取工单详情",
    description="获取工单详情",
    response_model=ResponseSchema[TicketOutSchema],
)
async def ticket_detail_controller(
    id: Annotated[int, Path(description="工单ID", ge=1)],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:ticket:detail"]))],
) -> JSONResponse:
    """
    获取工单详情。

    参数:
    - id (int): 工单ID。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含工单详情的响应模型。
    """
    result_dict = await TicketService.get_ticket_detail_service(auth=auth, id=id)
    log.info(f"获取工单详情成功 {id}")
    return SuccessResponse(data=result_dict, msg="查询成功")


@TicketRouter.post(
    "/create",
    summary="创建工单",
    description="创建工单",
    response_model=ResponseSchema[TicketOutSchema],
)
async def ticket_create_controller(
    data: TicketCreateSchema,
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:ticket:create"]))],
) -> JSONResponse:
    """
    创建工单。

    参数:
    - data (TicketCreateSchema): 工单创建负载模型。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含新建工单详情的响应模型。
    """
    result_dict = await TicketService.create_ticket_service(auth=auth, data=data)
    log.info(f"创建工单成功: {result_dict.get('id')}")
    return SuccessResponse(data=result_dict, msg="创建成功")


@TicketRouter.put(
    "/update/{id}",
    summary="更新工单",
    description="更新工单（状态变更受状态机守卫）",
    response_model=ResponseSchema[TicketOutSchema],
)
async def ticket_update_controller(
    data: TicketUpdateSchema,
    id: Annotated[int, Path(description="工单ID", ge=1)],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:ticket:update"]))],
) -> JSONResponse:
    """
    更新工单。

    参数:
    - data (TicketUpdateSchema): 工单更新负载模型。
    - id (int): 工单ID。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含更新后工单详情的响应模型。
    """
    result_dict = await TicketService.update_ticket_service(
        auth=auth, id=id, data=data
    )
    log.info(f"更新工单成功 {id}")
    return SuccessResponse(data=result_dict, msg="更新成功")


@TicketRouter.put(
    "/batch",
    summary="批量更新工单",
    description="批量流转工单状态（逐单过状态机守卫）",
    response_model=ResponseSchema[None],
)
async def ticket_batch_update_controller(
    data: TicketBatchSchema,
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:ticket:update"]))],
) -> JSONResponse:
    """
    批量更新工单状态。

    参数:
    - data (TicketBatchSchema): 工单批量更新负载模型。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含批量操作结果的响应模型。
    """
    await TicketService.batch_update_ticket_service(auth=auth, data=data)
    log.info(f"批量更新工单成功: {data.ids} -> {data.status}")
    return SuccessResponse(msg="批量操作成功")


@TicketRouter.delete(
    "/delete",
    summary="删除工单",
    description="删除工单",
    response_model=ResponseSchema[None],
)
async def ticket_delete_controller(
    ids: Annotated[list[int], Body(description="工单ID列表")],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:ticket:delete"]))],
) -> JSONResponse:
    """
    删除工单。

    参数:
    - ids (list[int]): 工单ID列表。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含删除结果的响应模型。
    """
    await TicketService.delete_ticket_service(auth=auth, ids=ids)
    log.info(f"删除工单成功: {ids}")
    return SuccessResponse(msg="删除成功")


@TicketRouter.post(
    "/export",
    summary="导出工单",
    description="按查询条件导出工单为 xlsx",
    response_model=ResponseSchema[None],
)
async def ticket_export_controller(
    search: Annotated[TicketQueryParam, Depends()],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:ticket:export"]))],
) -> StreamingResponse:
    """
    导出工单。

    参数:
    - search (TicketQueryParam): 查询工单参数模型。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - StreamingResponse: 包含导出工单的流式响应模型。
    """
    ticket_list = await TicketService.get_ticket_list_service(auth=auth, search=search)
    export_result = await TicketService.export_ticket_list_service(
        ticket_list=ticket_list
    )
    log.info("导出工单成功")

    return StreamResponse(
        data=bytes2file_response(export_result),
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": "attachment; filename=ticket.xlsx"},
    )


@TicketRouter.get(
    "/{ticket_id}/comments",
    summary="工单评论列表",
    description="分页查询某工单的评论",
    response_model=ResponseSchema[list[TicketCommentOutSchema]],
)
async def ticket_comment_list_controller(
    ticket_id: Annotated[int, Path(description="工单ID", ge=1)],
    page: Annotated[PaginationQueryParam, Depends()],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:ticket:detail"]))],
) -> JSONResponse:
    """
    分页查询工单评论。

    参数:
    - ticket_id (int): 工单ID。
    - page (PaginationQueryParam): 分页查询参数模型。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含分页评论详情的响应模型。
    """
    result_dict = await TicketCommentService.get_comment_page_service(
        auth=auth,
        ticket_id=ticket_id,
        page_no=page.page_no,
        page_size=page.page_size,
    )
    log.info(f"查询工单评论列表成功 {ticket_id}")
    return SuccessResponse(data=result_dict, msg="查询成功")


@TicketRouter.post(
    "/{ticket_id}/comments",
    summary="创建工单评论",
    description="创建工单评论",
    response_model=ResponseSchema[TicketCommentOutSchema],
)
async def ticket_comment_create_controller(
    data: TicketCommentCreateSchema,
    ticket_id: Annotated[int, Path(description="工单ID", ge=1)],
    auth: Annotated[AuthSchema, Depends(AuthPermission(["module_system:ticket:detail"]))],
) -> JSONResponse:
    """
    创建工单评论。

    参数:
    - data (TicketCommentCreateSchema): 评论内容负载模型。
    - ticket_id (int): 工单ID。
    - auth (AuthSchema): 认证信息模型。

    返回:
    - JSONResponse: 包含新建评论详情的响应模型。
    """
    result_dict = await TicketCommentService.create_comment_service(
        auth=auth, ticket_id=ticket_id, data=data
    )
    log.info(f"创建工单评论成功 {ticket_id}")
    return SuccessResponse(data=result_dict, msg="评论成功")
