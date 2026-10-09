from pydantic import BaseModel, ConfigDict, Field


class JWTOutSchema(BaseModel):
    """JWT响应模型"""

    model_config = ConfigDict(from_attributes=True)

    access_token: str = Field(..., min_length=1, description="访问token")
    refresh_token: str = Field(..., min_length=1, description="刷新token")
    token_type: str = Field(default="Bearer", description="token类型")
    expires_in: int = Field(..., gt=0, description="过期时间(秒)")


class WxLoginSchema(BaseModel):
    """微信小程序登录请求（code2Session）"""

    code: str = Field(..., min_length=1, description="uni.login 返回的临时登录凭证 code")
    nickname: str | None = Field(default=None, max_length=64, description="用户昵称（可选）")
    avatar: str | None = Field(default=None, max_length=512, description="头像 URL（可选）")


class WxPhoneLoginSchema(BaseModel):
    """微信小程序手机号登录请求"""

    code: str = Field(..., min_length=1, description="getPhoneNumber 回调返回的动态令牌 code")


class WxQrCodeSchema(BaseModel):
    """小程序码生成请求"""

    scene: str = Field(..., max_length=32, description="场景参数（如 invite=xxx，最大32字符）")
    page: str | None = Field(default=None, max_length=128, description="小程序页面路径，为空则默认主页")
    width: int = Field(default=430, ge=280, le=1280, description="小程序码宽度（px）")


class WxQrCodeOutSchema(BaseModel):
    """小程序码生成响应"""

    model_config = ConfigDict(from_attributes=True)

    url: str = Field(..., description="小程序码图片（base64 data URI，可直接作 img src）")


class RefreshTokenPayloadSchema(BaseModel):
    """刷新Token载荷模型"""

    refresh_token: str = Field(..., min_length=1, description="刷新token")


class CaptchaOutSchema(BaseModel):
    """验证码响应模型"""

    model_config = ConfigDict(from_attributes=True)

    enable: bool = Field(default=True, description="是否启用验证码")
    key: str = Field(..., min_length=1, description="验证码唯一标识")
    img_base: str = Field(..., min_length=1, description="Base64编码的验证码图片")


class AutoLoginUserSchema(BaseModel):
    """免登录用户信息模型"""

    model_config = ConfigDict(from_attributes=True)

    id: int = Field(..., description="用户ID")
    username: str = Field(..., description="用户名")
    name: str = Field(..., description="用户姓名")
    avatar: str | None = Field(default=None, description="头像")


class AutoLoginTokenSchema(BaseModel):
    """免登录Token响应模型"""

    model_config = ConfigDict(from_attributes=True)

    token: str = Field(..., description="免登录Token")
    user: AutoLoginUserSchema = Field(..., description="用户信息")
