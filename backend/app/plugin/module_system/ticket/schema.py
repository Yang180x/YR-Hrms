from fastapi import Query
from pydantic import BaseModel, ConfigDict, Field, field_validator

from app.common.enums import QueueEnum, TicketTypeEnum
from app.core.base_schema import BaseSchema, CommonSchema, UserBySchema
from app.core.validator import DateTimeStr
from app.utils.xss_util import sanitize_html


class TicketCreateSchema(BaseModel):
    """创建工单"""

    title: str = Field(..., min_length=1, max_length=200, description="工单标题")
    ticket_content: str = Field(default="", description="工单内容（富文本）")
    summary: str | None = Field(default=None, description="工单内容（纯文本摘要）")
    ticket_type: TicketTypeEnum = Field(
        default=TicketTypeEnum.SUGGESTION,
        description="工单类型(suggestion/bug/optimize/other)",
    )
    images: str | None = Field(default=None, description="图片URL列表(JSON数组)")
    description: str | None = Field(default=None, max_length=255, description="工单描述")

    @field_validator("title")
    @classmethod
    def _validate_title(cls, value: str) -> str:
        """标题去首尾空白，拒绝全空白。"""
        value = value.strip()
        if not value:
            raise ValueError("工单标题不能为空")
        return value

    @field_validator("ticket_content")
    @classmethod
    def _sanitize_content(cls, value: str) -> str:
        """富文本内容过 XSS 清洗（与公告 notice_content 同口径）。"""
        return sanitize_html(value) if value else value


class TicketUpdateSchema(BaseModel):
    """更新工单"""

    title: str | None = Field(default=None, max_length=200, description="工单标题")
    ticket_content: str | None = Field(default=None, description="工单内容（富文本）")
    summary: str | None = Field(default=None, description="工单内容（纯文本摘要）")
    ticket_type: TicketTypeEnum | None = Field(default=None, description="工单类型")
    status: int | None = Field(
        default=None, ge=0, le=3, description="状态(0:待处理 1:处理中 2:已完成 3:已关闭)"
    )
    reply: str | None = Field(default=None, description="回复内容")
    assigned_id: int | None = Field(default=None, gt=0, description="处理人ID")
    description: str | None = Field(default=None, max_length=255, description="工单描述")

    @field_validator("title")
    @classmethod
    def _validate_title(cls, value: str | None) -> str | None:
        """标题去首尾空白；None 透传。"""
        if value is None:
            return None
        value = value.strip()
        if not value:
            raise ValueError("工单标题不能为空")
        return value

    @field_validator("ticket_content")
    @classmethod
    def _sanitize_content(cls, value: str | None) -> str | None:
        """富文本内容过 XSS 清洗；None 透传。"""
        if value:
            return sanitize_html(value)
        return value


class TicketOutSchema(BaseSchema, UserBySchema):
    """工单响应

    status 重定义为 int（覆盖 BaseSchema 的 str）。
    """

    model_config = ConfigDict(from_attributes=True)

    title: str = Field(..., description="工单标题")
    ticket_content: str | None = Field(default=None, description="工单内容")
    summary: str | None = Field(default=None, description="摘要")
    ticket_type: TicketTypeEnum = Field(..., description="工单类型")
    status: int = Field(  # type: ignore[override]
        ..., description="状态(0:待处理 1:处理中 2:已完成 3:已关闭)"
    )
    images: str | None = Field(default=None, description="图片")
    reply: str | None = Field(default=None, description="回复内容")
    assigned_id: int | None = Field(default=None, description="指派人ID")
    assigned_by: CommonSchema | None = Field(default=None, description="指派人")


class TicketBatchSchema(BaseModel):
    """批量更新工单"""

    ids: list[int] = Field(..., min_length=1, description="工单ID列表")
    status: int = Field(..., ge=0, le=3, description="状态(0:待处理 1:处理中 2:已完成 3:已关闭)")


class TicketStatsSchema(BaseModel):
    """工单状态聚合统计（已关闭不计入）"""

    pending: int = Field(default=0, description="待处理数量")
    processing: int = Field(default=0, description="处理中数量")
    done: int = Field(default=0, description="已完成数量")


class TicketQueryParam:
    """工单查询参数（我方 tuple DSL 风格）

    注意 status 用裸值传递：内核 ``__build_conditions`` 对 ``("eq", 0)`` 的
    ``val`` 做真值判断，0 会被静默丢弃导致「待处理」过滤失效；裸值走
    ``attr == value`` 分支不受影响。
    """

    def __init__(
        self,
        title: str | None = Query(None, description="工单标题"),
        ticket_type: str | None = Query(None, description="工单类型"),
        assigned_id: int | None = Query(None, description="处理人ID"),
        status: int | None = Query(
            None, ge=0, le=3, description="状态(0:待处理 1:处理中 2:已完成 3:已关闭)"
        ),
        created_time: list[DateTimeStr] | None = Query(
            None,
            description="创建时间范围",
            examples=["2025-01-01 00:00:00", "2025-12-31 23:59:59"],
        ),
        updated_time: list[DateTimeStr] | None = Query(
            None,
            description="更新时间范围",
            examples=["2025-01-01 00:00:00", "2025-12-31 23:59:59"],
        ),
        created_id: int | None = Query(None, description="创建人"),
        updated_id: int | None = Query(None, description="更新人"),
    ) -> None:
        # 模糊查询字段（无条件赋值：保证 search.__dict__ 非空，
        # 否则 CRUD.page 对空 dict 跳过 __build_conditions → 软删过滤被旁路）
        self.title = (QueueEnum.like.value, title)
        # 精确查询字段（裸值：status=0 必须可过滤；None 由 build_conditions 跳过）
        self.ticket_type = ticket_type
        self.assigned_id = assigned_id
        self.status = status
        # 时间范围查询
        if created_time and len(created_time) == 2:
            self.created_time = (QueueEnum.between.value, (created_time[0], created_time[1]))
        if updated_time and len(updated_time) == 2:
            self.updated_time = (QueueEnum.between.value, (updated_time[0], updated_time[1]))
        # 关联查询字段
        if created_id:
            self.created_id = created_id
        if updated_id:
            self.updated_id = updated_id


class TicketCommentCreateSchema(BaseModel):
    """创建评论"""

    content: str = Field(..., min_length=1, description="评论内容")

    @field_validator("content")
    @classmethod
    def _sanitize_content(cls, value: str) -> str:
        """评论富文本过 XSS 清洗。"""
        return sanitize_html(value)


class TicketCommentOutSchema(BaseSchema, UserBySchema):
    """评论响应（created_by_name 由 service 从 created_by.name 回填）"""

    model_config = ConfigDict(from_attributes=True)

    ticket_id: int
    content: str
    created_by_name: str | None = None
