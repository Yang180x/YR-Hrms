from fastapi import Query
from pydantic import BaseModel, ConfigDict, Field, field_validator

from app.common.enums import QueueEnum
from app.core.validator import DateTimeStr
from app.utils.xss_util import sanitize_html


class VersionCreateSchema(BaseModel):
    """版本创建模型"""

    version: str = Field(..., max_length=32, description="版本号")
    title: str = Field(..., max_length=200, description="版本标题")
    date: str = Field(..., max_length=50, description="发布日期")
    content: str | None = Field(default=None, description="更新内容(富文本HTML)")
    description: str | None = Field(default=None, max_length=500, description="备注")
    sort: int = Field(default=0, description="排序")
    status: int = Field(default=0, description="状态: 0=草稿,1=已发布,2=已回滚")
    require_re_login: bool = Field(default=False, description="是否需要重新登录")

    @field_validator("content")
    @classmethod
    def _sanitize_content(cls, value: str | None) -> str | None:
        """富文本内容过 XSS 清洗（与公告 notice_content 同口径）。"""
        if value:
            return sanitize_html(value)
        return value

    @field_validator("version", "title", "date")
    @classmethod
    def _strip_required(cls, value: str) -> str:
        """必填文本去首尾空白，拒绝全空白。"""
        stripped = value.strip()
        if not stripped:
            raise ValueError("版本号/标题/日期不能为空")
        return stripped


class VersionUpdateSchema(VersionCreateSchema):
    """版本更新模型"""


class VersionOutSchema(VersionCreateSchema):
    """版本响应模型（不继承 BaseSchema：status 为 int，与 BaseSchema 的 str 冲突）"""

    model_config = ConfigDict(from_attributes=True)

    id: int = Field(description="主键ID")
    created_time: DateTimeStr | None = Field(default=None, description="创建时间")
    updated_time: DateTimeStr | None = Field(default=None, description="更新时间")


class VersionStatusSchema(BaseModel):
    """版本状态更新模型"""

    status: int = Field(..., description="状态: 0=草稿,1=已发布,2=已回滚")

    @field_validator("status")
    @classmethod
    def _validate_status(cls, value: int) -> int:
        """状态仅允许 0/1/2。"""
        if value not in (0, 1, 2):
            raise ValueError("status must be 0, 1, or 2")
        return value


class VersionQueryParam:
    """版本查询参数（我方 tuple DSL 风格，与 NoticeQueryParam 同构）

    注意 status 用裸值传递：内核 ``__build_conditions`` 对 ``("eq", 0)`` 的
    ``val`` 做真值判断，0 会被静默丢弃导致草稿过滤失效；裸值走 ``attr == value``
    分支不受影响。
    """

    def __init__(
        self,
        version: str | None = Query(None, description="版本号"),
        status: int | None = Query(
            None, description="状态: 0=草稿,1=已发布,2=已回滚"
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
        self.version = (QueueEnum.like.value, version)
        # 精确查询字段（裸值：status=0 必须可过滤；None 由 build_conditions 跳过）
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
