/* eslint-disable */
// @ts-ignore

export type AutoLoginTokenSchema = {
  /** Token 免登录Token */
  token: string;
  /** 用户信息 */
  user: AutoLoginUserSchema;
};

export type AutoLoginUserSchema = {
  /** Id 用户ID */
  id: number;
  /** Username 用户名 */
  username: string;
  /** Name 用户姓名 */
  name: string;
  /** Avatar 头像 */
  avatar?: string | null;
};

export type BatchSetAvailable = {
  /** Ids ID列表 */
  ids?: number[];
  /** Status 是否可用 */
  status?: string;
};

export type BodyImportObjListControllerSystemUserImportDataPost = {
  /** File */
  file: string;
};

export type BodyLoginForAccessTokenControllerSystemAuthLoginPost = {
  /** Grant Type */
  grant_type?: string | null;
  /** Scope */
  scope?: string;
  /** Client Id */
  client_id?: string | null;
  /** Client Secret */
  client_secret?: string | null;
  /** Username */
  username: string;
  /** Password */
  password: string;
  /** Captcha Key */
  captcha_key?: string | null;
  /** Captcha */
  captcha?: string | null;
  /** Login Type PC | FLUTTER | UNIAPP */
  login_type?: string | null;
};

export type BodyUploadFileControllerSystemParamUploadPost = {
  /** File */
  file: string;
};

export type BodyUserAvatarUploadControllerSystemUserCurrentAvatarUploadPost = {
  /** File */
  file: string;
};

export type CaptchaOutSchema = {
  /** Enable 是否启用验证码 */
  enable?: boolean;
  /** Key 验证码唯一标识 */
  key: string;
  /** Img Base Base64编码的验证码图片 */
  img_base: string;
};

export enum ClientEnum {
  'pc' = 'pc',
  'app' = 'app',
}

export type IClientEnum = keyof typeof ClientEnum;

export enum ClientEnum2 {
  'pc' = 'pc',
  'app' = 'app',
}

export type IClientEnum2 = keyof typeof ClientEnum2;

export enum ClientEnum3 {
  'pc' = 'pc',
  'app' = 'app',
}

export type IClientEnum3 = keyof typeof ClientEnum3;

export type CommonSchema = {
  /** Id 编号ID */
  id: number;
  /** Name 名称 */
  name: string;
};

export type CurrentUserUpdateSchema = {
  /** Name 名称 */
  name?: string | null;
  /** Mobile 手机号 */
  mobile?: string | null;
  /** Email 邮箱 */
  email?: string | null;
  /** Gender 性别 */
  gender?: string | null;
  /** Avatar 头像 */
  avatar?: string | null;
  /** Id Card 身份证号 */
  id_card?: string | null;
};

export type DeptCreateSchema = {
  /** Name 部门名称 */
  name: string;
  /** Order 显示顺序 */
  order?: number;
  /** Code 部门编码 */
  code: string;
  /** Leader 部门负责人 */
  leader?: string | null;
  /** Phone 手机 */
  phone?: string | null;
  /** Email 邮箱 */
  email?: string | null;
  /** Parent Id 父部门ID */
  parent_id?: number | null;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 备注说明 */
  description?: string | null;
};

export type DeptOutSchema = {
  /** Id 主键ID */
  id?: number | null;
  /** Uuid UUID */
  uuid?: string | null;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 备注说明 */
  description?: string | null;
  /** Created Time 创建时间 */
  created_time?: string | null;
  /** Updated Time 更新时间 */
  updated_time?: string | null;
  /** Is Deleted 是否已删除 */
  is_deleted?: boolean;
  /** Deleted Time 删除时间 */
  deleted_time?: string | null;
  /** Name 部门名称 */
  name: string;
  /** Order 显示顺序 */
  order?: number;
  /** Code 部门编码 */
  code: string;
  /** Leader 部门负责人 */
  leader?: string | null;
  /** Phone 手机 */
  phone?: string | null;
  /** Email 邮箱 */
  email?: string | null;
  /** Parent Id 父部门ID */
  parent_id?: number | null;
  /** Parent Name 父部门名称 */
  parent_name?: string | null;
};

export type DeptUpdateSchema = {
  /** Name 部门名称 */
  name: string;
  /** Order 显示顺序 */
  order?: number;
  /** Code 部门编码 */
  code: string;
  /** Leader 部门负责人 */
  leader?: string | null;
  /** Phone 手机 */
  phone?: string | null;
  /** Email 邮箱 */
  email?: string | null;
  /** Parent Id 父部门ID */
  parent_id?: number | null;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 备注说明 */
  description?: string | null;
};

export type DictDataCreateSchema = {
  /** Dict Sort 字典排序 */
  dict_sort: number;
  /** Dict Label 字典标签 */
  dict_label: string;
  /** Dict Value 字典键值 */
  dict_value: string;
  /** Dict Type 字典类型 */
  dict_type: string;
  /** Dict Type Id 字典类型ID */
  dict_type_id: number;
  /** Css Class 样式属性（其他样式扩展） */
  css_class?: string | null;
  /** List Class 表格回显样式 */
  list_class?: string | null;
  /** Is Default 是否默认（True是 False否） */
  is_default?: boolean;
  /** Status 状态（0正常 1停用） */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type DictDataOutSchema = {
  /** Id 主键ID */
  id?: number | null;
  /** Uuid UUID */
  uuid?: string | null;
  /** Status 状态（0正常 1停用） */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Created Time 创建时间 */
  created_time?: string | null;
  /** Updated Time 更新时间 */
  updated_time?: string | null;
  /** Is Deleted 是否已删除 */
  is_deleted?: boolean;
  /** Deleted Time 删除时间 */
  deleted_time?: string | null;
  /** Dict Sort 字典排序 */
  dict_sort: number;
  /** Dict Label 字典标签 */
  dict_label: string;
  /** Dict Value 字典键值 */
  dict_value: string;
  /** Dict Type 字典类型 */
  dict_type: string;
  /** Dict Type Id 字典类型ID */
  dict_type_id: number;
  /** Css Class 样式属性（其他样式扩展） */
  css_class?: string | null;
  /** List Class 表格回显样式 */
  list_class?: string | null;
  /** Is Default 是否默认（True是 False否） */
  is_default?: boolean;
};

export type DictDataUpdateSchema = {
  /** Dict Sort 字典排序 */
  dict_sort: number;
  /** Dict Label 字典标签 */
  dict_label: string;
  /** Dict Value 字典键值 */
  dict_value: string;
  /** Dict Type 字典类型 */
  dict_type: string;
  /** Dict Type Id 字典类型ID */
  dict_type_id: number;
  /** Css Class 样式属性（其他样式扩展） */
  css_class?: string | null;
  /** List Class 表格回显样式 */
  list_class?: string | null;
  /** Is Default 是否默认（True是 False否） */
  is_default?: boolean;
  /** Status 状态（0正常 1停用） */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type DictTypeCreateSchema = {
  /** Dict Name 字典名称 */
  dict_name: string;
  /** Dict Type 字典类型 */
  dict_type: string;
  /** Status 状态（0正常 1停用） */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type DictTypeOutSchema = {
  /** Id 主键ID */
  id?: number | null;
  /** Uuid UUID */
  uuid?: string | null;
  /** Status 状态（0正常 1停用） */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Created Time 创建时间 */
  created_time?: string | null;
  /** Updated Time 更新时间 */
  updated_time?: string | null;
  /** Is Deleted 是否已删除 */
  is_deleted?: boolean;
  /** Deleted Time 删除时间 */
  deleted_time?: string | null;
  /** Dict Name 字典名称 */
  dict_name: string;
  /** Dict Type 字典类型 */
  dict_type: string;
};

export type DictTypeUpdateSchema = {
  /** Dict Name 字典名称 */
  dict_name: string;
  /** Dict Type 字典类型 */
  dict_type: string;
  /** Status 状态（0正常 1停用） */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type JWTOutSchema = {
  /** Access Token 访问token */
  access_token: string;
  /** Refresh Token 刷新token */
  refresh_token: string;
  /** Token Type token类型 */
  token_type?: string;
  /** Expires In 过期时间(秒) */
  expires_in: number;
};

export type MenuCreateSchema = {
  /** Name 菜单名称 */
  name: string;
  /** Type 菜单类型(1:目录 2:菜单 3:按钮 4:外链) */
  type: number;
  /** Order 显示顺序 */
  order: number;
  /** Permission 权限标识 */
  permission?: string | null;
  /** Icon 菜单图标 */
  icon?: string | null;
  /** Route Name 路由名称 */
  route_name?: string | null;
  /** Route Path 路由地址 */
  route_path?: string | null;
  /** Component Path 组件路径 */
  component_path?: string | null;
  /** Redirect 重定向地址 */
  redirect?: string | null;
  /** Hidden 是否隐藏(True:是 False:否) */
  hidden?: boolean;
  /** Keep Alive 是否缓存(True:是 False:否) */
  keep_alive?: boolean;
  /** Always Show 是否始终显示(True:是 False:否) */
  always_show?: boolean;
  /** Title 菜单标题 */
  title?: string | null;
  /** Params 路由参数，格式为[{key: string, value: string}] */
  params?: Record<string, string>[] | null;
  /** Affix 是否固定标签页(True:是 False:否) */
  affix?: boolean;
  /** Parent Id 父菜单ID */
  parent_id?: number | null;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Client 终端(pc:管理端桌面 app:移动端) */
  client?: 'pc' | 'app';
};

export type MenuOutSchema = {
  /** Id 主键ID */
  id?: number | null;
  /** Uuid UUID */
  uuid?: string | null;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Created Time 创建时间 */
  created_time?: string | null;
  /** Updated Time 更新时间 */
  updated_time?: string | null;
  /** Is Deleted 是否已删除 */
  is_deleted?: boolean;
  /** Deleted Time 删除时间 */
  deleted_time?: string | null;
  /** Name 菜单名称 */
  name: string;
  /** Type 菜单类型(1:目录 2:菜单 3:按钮 4:外链) */
  type: number;
  /** Order 显示顺序 */
  order: number;
  /** Permission 权限标识 */
  permission?: string | null;
  /** Icon 菜单图标 */
  icon?: string | null;
  /** Route Name 路由名称 */
  route_name?: string | null;
  /** Route Path 路由地址 */
  route_path?: string | null;
  /** Component Path 组件路径 */
  component_path?: string | null;
  /** Redirect 重定向地址 */
  redirect?: string | null;
  /** Hidden 是否隐藏(True:是 False:否) */
  hidden?: boolean;
  /** Keep Alive 是否缓存(True:是 False:否) */
  keep_alive?: boolean;
  /** Always Show 是否始终显示(True:是 False:否) */
  always_show?: boolean;
  /** Title 菜单标题 */
  title?: string | null;
  /** Params 路由参数，格式为[{key: string, value: string}] */
  params?: Record<string, string>[] | null;
  /** Affix 是否固定标签页(True:是 False:否) */
  affix?: boolean;
  /** Parent Id 父菜单ID */
  parent_id?: number | null;
  /** Client 终端(pc:管理端桌面 app:移动端) */
  client?: 'pc' | 'app';
  /** Parent Name 父菜单名称 */
  parent_name?: string | null;
};

export type MenuUpdateSchema = {
  /** Name 菜单名称 */
  name: string;
  /** Type 菜单类型(1:目录 2:菜单 3:按钮 4:外链) */
  type: number;
  /** Order 显示顺序 */
  order: number;
  /** Permission 权限标识 */
  permission?: string | null;
  /** Icon 菜单图标 */
  icon?: string | null;
  /** Route Name 路由名称 */
  route_name?: string | null;
  /** Route Path 路由地址 */
  route_path?: string | null;
  /** Component Path 组件路径 */
  component_path?: string | null;
  /** Redirect 重定向地址 */
  redirect?: string | null;
  /** Hidden 是否隐藏(True:是 False:否) */
  hidden?: boolean;
  /** Keep Alive 是否缓存(True:是 False:否) */
  keep_alive?: boolean;
  /** Always Show 是否始终显示(True:是 False:否) */
  always_show?: boolean;
  /** Title 菜单标题 */
  title?: string | null;
  /** Params 路由参数，格式为[{key: string, value: string}] */
  params?: Record<string, string>[] | null;
  /** Affix 是否固定标签页(True:是 False:否) */
  affix?: boolean;
  /** Parent Id 父菜单ID */
  parent_id?: number | null;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Client 终端(pc:管理端桌面 app:移动端) */
  client?: 'pc' | 'app';
  /** Parent Name 父菜单名称 */
  parent_name?: string | null;
};

export type NoticeCreateSchema = {
  /** Notice Title 公告标题 */
  notice_title: string;
  /** Notice Type 公告类型（1通知 2公告） */
  notice_type: string;
  /** Notice Content 公告内容 */
  notice_content: string;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type NoticeOutSchema = {
  /** Created Id 创建人ID */
  created_id?: number | null;
  /** 创建人信息 */
  created_by?: CommonSchema | null;
  /** Updated Id 更新人ID */
  updated_id?: number | null;
  /** 更新人信息 */
  updated_by?: CommonSchema | null;
  /** Deleted Id 删除人ID */
  deleted_id?: number | null;
  /** 删除人信息 */
  deleted_by?: CommonSchema | null;
  /** Id 主键ID */
  id?: number | null;
  /** Uuid UUID */
  uuid?: string | null;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Created Time 创建时间 */
  created_time?: string | null;
  /** Updated Time 更新时间 */
  updated_time?: string | null;
  /** Is Deleted 是否已删除 */
  is_deleted?: boolean;
  /** Deleted Time 删除时间 */
  deleted_time?: string | null;
  /** Notice Title 公告标题 */
  notice_title: string;
  /** Notice Type 公告类型（1通知 2公告） */
  notice_type: string;
  /** Notice Content 公告内容 */
  notice_content: string;
};

export type NoticeUpdateSchema = {
  /** Notice Title 公告标题 */
  notice_title: string;
  /** Notice Type 公告类型（1通知 2公告） */
  notice_type: string;
  /** Notice Content 公告内容 */
  notice_content: string;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type OperationLogOutSchema = {
  /** Created Id 创建人ID */
  created_id?: number | null;
  /** 创建人信息 */
  created_by?: CommonSchema | null;
  /** Updated Id 更新人ID */
  updated_id?: number | null;
  /** 更新人信息 */
  updated_by?: CommonSchema | null;
  /** Deleted Id 删除人ID */
  deleted_id?: number | null;
  /** 删除人信息 */
  deleted_by?: CommonSchema | null;
  /** Id 主键ID */
  id?: number | null;
  /** Uuid UUID */
  uuid?: string | null;
  /** Status 是否成功 */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Created Time 创建时间 */
  created_time?: string | null;
  /** Updated Time 更新时间 */
  updated_time?: string | null;
  /** Is Deleted 是否已删除 */
  is_deleted?: boolean;
  /** Deleted Time 删除时间 */
  deleted_time?: string | null;
  /** Type 日志类型(1登录日志 2操作日志) */
  type?: number | null;
  /** Request Path 请求路径 */
  request_path?: string | null;
  /** Request Method 请求方法 */
  request_method?: string | null;
  /** Request Payload 请求负载 */
  request_payload?: string | null;
  /** Request Ip 请求 IP 地址 */
  request_ip?: string | null;
  /** Login Location 登录位置 */
  login_location?: string | null;
  /** Request Os 请求操作系统 */
  request_os?: string | null;
  /** Request Browser 请求浏览器 */
  request_browser?: string | null;
  /** Response Code 响应状态码 */
  response_code?: number | null;
  /** Response Json 响应 JSON 数据 */
  response_json?: string | null;
  /** Process Time 处理时间 */
  process_time?: string | null;
  /** Signature SM2签名值 */
  signature?: string | null;
  /** Signed Fields 被签名字段标识 */
  signed_fields?: string | null;
  /** Username 操作人账号 */
  username?: string | null;
  /** Mobile 操作人手机号 */
  mobile?: string | null;
  /** Login Platform 登录平台 */
  login_platform?: string | null;
};

export type ParamsCreateSchema = {
  /** Config Name 参数名称 */
  config_name: string;
  /** Config Key 参数键名 */
  config_key: string;
  /** Config Value 参数键值 */
  config_value?: string | null;
  /** Config Type 系统内置(True:是 False:否) */
  config_type?: boolean;
  /** Status 状态(True:正常 False:停用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type ParamsOutSchema = {
  /** Id 主键ID */
  id?: number | null;
  /** Uuid UUID */
  uuid?: string | null;
  /** Status 状态(True:正常 False:停用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Created Time 创建时间 */
  created_time?: string | null;
  /** Updated Time 更新时间 */
  updated_time?: string | null;
  /** Is Deleted 是否已删除 */
  is_deleted?: boolean;
  /** Deleted Time 删除时间 */
  deleted_time?: string | null;
  /** Config Name 参数名称 */
  config_name: string;
  /** Config Key 参数键名 */
  config_key: string;
  /** Config Value 参数键值 */
  config_value?: string | null;
  /** Config Type 系统内置(True:是 False:否) */
  config_type?: boolean;
};

export type ParamsUpdateSchema = {
  /** Config Name 参数名称 */
  config_name: string;
  /** Config Key 参数键名 */
  config_key: string;
  /** Config Value 参数键值 */
  config_value?: string | null;
  /** Config Type 系统内置(True:是 False:否) */
  config_type?: boolean;
  /** Status 状态(True:正常 False:停用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type PositionCreateSchema = {
  /** Name 岗位名称 */
  name: string;
  /** Order 显示排序 */
  order?: number;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type PositionOutSchema = {
  /** Created Id 创建人ID */
  created_id?: number | null;
  /** 创建人信息 */
  created_by?: CommonSchema | null;
  /** Updated Id 更新人ID */
  updated_id?: number | null;
  /** 更新人信息 */
  updated_by?: CommonSchema | null;
  /** Deleted Id 删除人ID */
  deleted_id?: number | null;
  /** 删除人信息 */
  deleted_by?: CommonSchema | null;
  /** Id 主键ID */
  id?: number | null;
  /** Uuid UUID */
  uuid?: string | null;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Created Time 创建时间 */
  created_time?: string | null;
  /** Updated Time 更新时间 */
  updated_time?: string | null;
  /** Is Deleted 是否已删除 */
  is_deleted?: boolean;
  /** Deleted Time 删除时间 */
  deleted_time?: string | null;
  /** Name 岗位名称 */
  name: string;
  /** Order 显示排序 */
  order?: number;
};

export type PositionUpdateSchema = {
  /** Name 岗位名称 */
  name: string;
  /** Order 显示排序 */
  order?: number;
  /** Status 是否启用(0:启用 1:禁用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type RefreshTokenPayloadSchema = {
  /** Refresh Token 刷新token */
  refresh_token: string;
};

export type ResetPasswordSchema = {
  /** Id 主键ID */
  id: number;
  /** Password 新密码 */
  password: string;
};

export type ResponseSchemaDeptOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** 响应数据 */
  data?: DeptOutSchema | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaDict_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: Record<string, unknown> | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaDictDataOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** 响应数据 */
  data?: DictDataOutSchema | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaDictTypeOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** 响应数据 */
  data?: DictTypeOutSchema | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaListDeptOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: DeptOutSchema[] | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaListDictDataOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: DictDataOutSchema[] | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaListDictTypeOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: DictTypeOutSchema[] | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaListMenuOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: MenuOutSchema[] | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaListNoticeOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: NoticeOutSchema[] | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaListOperationLogOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: OperationLogOutSchema[] | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaListParamsOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: ParamsOutSchema[] | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaListPositionOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: PositionOutSchema[] | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaListRoleOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: RoleOutSchema[] | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaListUserOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: UserOutSchema[] | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaMenuOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** 响应数据 */
  data?: MenuOutSchema | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaNoneType_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** Data 响应数据 */
  data?: null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaNoticeOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** 响应数据 */
  data?: NoticeOutSchema | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaOperationLogOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** 响应数据 */
  data?: OperationLogOutSchema | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaParamsOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** 响应数据 */
  data?: ParamsOutSchema | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaPositionOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** 响应数据 */
  data?: PositionOutSchema | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaRoleOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** 响应数据 */
  data?: RoleOutSchema | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaTenantOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** 响应数据 */
  data?: TenantOutSchema | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type ResponseSchemaUserOutSchema_ = {
  /** Code 业务状态码 */
  code?: number;
  /** Msg 响应消息 */
  msg?: string;
  /** 响应数据 */
  data?: UserOutSchema | null;
  /** Status Code HTTP状态码 */
  status_code?: number;
  /** Success 操作是否成功 */
  success?: boolean;
};

export type RoleCreateSchema = {
  /** Name 角色名称 */
  name: string;
  /** Code 角色编码 */
  code: string;
  /** Order 显示排序 */
  order?: number | null;
  /** Data Scope 数据权限范围(1:仅本人 2:本部门 3:本部门及以下 4:全部 5:自定义) */
  data_scope?: number | null;
  /** Status 是否启用 */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type RoleOutSchema = {
  /** Id 主键ID */
  id?: number | null;
  /** Uuid UUID */
  uuid?: string | null;
  /** Status 是否启用 */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Created Time 创建时间 */
  created_time?: string | null;
  /** Updated Time 更新时间 */
  updated_time?: string | null;
  /** Is Deleted 是否已删除 */
  is_deleted?: boolean;
  /** Deleted Time 删除时间 */
  deleted_time?: string | null;
  /** Name 角色名称 */
  name: string;
  /** Code 角色编码 */
  code: string;
  /** Order 显示排序 */
  order?: number | null;
  /** Data Scope 数据权限范围(1:仅本人 2:本部门 3:本部门及以下 4:全部 5:自定义) */
  data_scope?: number | null;
  /** Menus 角色菜单列表 */
  menus?: MenuOutSchema[];
  /** Depts 角色部门列表 */
  depts?: DeptOutSchema[];
};

export type RolePermissionSettingSchema = {
  /** Data Scope 数据权限范围(1:仅本人 2:本部门 3:本部门及以下 4:全部 5:自定义) */
  data_scope?: number;
  /** Role Ids 角色ID列表 */
  role_ids?: number[];
  /** Menu Ids 菜单ID列表 */
  menu_ids?: number[];
  /** Dept Ids 部门ID列表 */
  dept_ids?: number[];
};

export type RoleUpdateSchema = {
  /** Name 角色名称 */
  name: string;
  /** Code 角色编码 */
  code: string;
  /** Order 显示排序 */
  order?: number | null;
  /** Data Scope 数据权限范围(1:仅本人 2:本部门 3:本部门及以下 4:全部 5:自定义) */
  data_scope?: number | null;
  /** Status 是否启用 */
  status?: string;
  /** Description 描述 */
  description?: string | null;
};

export type SystemAuthAutoLoginTokenUsingPostParams = {
  user_id: number;
};

export type SystemAuthAutoLoginTokenUsingPostResponses = {
  /**
   * 成功
   */
  200: AutoLoginTokenSchema;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemAuthAutoLoginUsersUsingGetResponses = {
  /**
   * 成功
   */
  200: AutoLoginUserSchema[];
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemAuthAutoLoginUsingPostParams = {
  token: string;
};

export type SystemAuthAutoLoginUsingPostResponses = {
  /**
   * 成功
   */
  200: JWTOutSchema;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemAuthCaptchaGetUsingGetResponses = {
  /**
   * 成功
   */
  200: CaptchaOutSchema;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemAuthLoginUsingPostResponses = {
  /**
   * 成功
   */
  200: JWTOutSchema;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemAuthLogoutUsingPostResponses = {
  /**
   * 成功
   */
  200: unknown;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemAuthOauthProviderLoginUsingGetParams = {
  /** wechat | qq | github | gitee */
  provider: 'wechat' | 'qq' | 'github' | 'gitee';
  /** OAuth 完成后浏览器回到的前端登录页完整 URL */
  redirect_uri?: string | null;
};

export type SystemAuthOauthProviderLoginUsingGetResponses = {
  /**
   * 成功
   */
  200: unknown;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemAuthSmPublicKeyUsingGetResponses = {
  /**
   * 成功
   */
  200: unknown;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemAuthTokenRefreshUsingPostResponses = {
  /**
   * 成功
   */
  200: JWTOutSchema;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemAuthWxLoginUsingPostResponses = {
  /**
   * 成功
   */
  200: JWTOutSchema;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemAuthWxPhoneLoginUsingPostResponses = {
  /**
   * 成功
   */
  200: JWTOutSchema;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemAuthWxQrcodeGenerateUsingPostResponses = {
  /**
   * 成功
   */
  200: WxQrCodeOutSchema;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDeptAvailableSettingUsingPatchResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDeptCreateUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaDeptOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDeptDetailIdUsingGetParams = {
  /** 部门ID */
  id: number;
};

export type SystemDeptDetailIdUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaDeptOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDeptOpenApiDeleteUsingDeleteBody = number[];

export type SystemDeptOpenApiDeleteUsingDeleteResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDeptTreeUsingGetParams = {
  /** 部门名称 */
  name?: string | null;
  /** 部门状态(True正常 False停用) */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
};

export type SystemDeptTreeUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListDeptOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDeptUpdateIdUsingPutParams = {
  /** 部门ID */
  id: number;
};

export type SystemDeptUpdateIdUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaDeptOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictDataAvailableSettingUsingPatchResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictDataCreateUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaDictDataOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictDataDetailIdUsingGetParams = {
  /** 字典数据ID */
  id: number;
};

export type SystemDictDataDetailIdUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaDictDataOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictDataInfoDictTypeUsingGetParams = {
  dict_type: string;
};

export type SystemDictDataInfoDictTypeUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListDictDataOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictDataListUsingGetParams = {
  /** 当前页码 */
  page_no?: number;
  /** 每页数量 */
  page_size?: number;
  /** 排序字段,格式:[{'field1': 'asc'}, {'field2': 'desc'}] */
  order_by?: string | null;
  /** 字典标签 */
  dict_label?: string | null;
  /** 字典类型 */
  dict_type?: string | null;
  /** 字典类型ID */
  dict_type_id?: number | null;
  /** 状态（0正常 1停用） */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
};

export type SystemDictDataListUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListDictDataOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictDataOpenApiDeleteUsingDeleteBody = number[];

export type SystemDictDataOpenApiDeleteUsingDeleteResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictDataOpenApiExportUsingPostParams = {
  /** 字典标签 */
  dict_label?: string | null;
  /** 字典类型 */
  dict_type?: string | null;
  /** 字典类型ID */
  dict_type_id?: number | null;
  /** 状态（0正常 1停用） */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
  /** 当前页码 */
  page_no?: number;
  /** 每页数量 */
  page_size?: number;
  /** 排序字段,格式:[{'field1': 'asc'}, {'field2': 'desc'}] */
  order_by?: string | null;
};

export type SystemDictDataOpenApiExportUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictDataUpdateIdUsingPutParams = {
  /** 字典数据ID */
  id: number;
};

export type SystemDictDataUpdateIdUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaDictDataOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictTypeAvailableSettingUsingPatchResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictTypeCreateUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaDictTypeOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictTypeDetailIdUsingGetParams = {
  /** 字典类型ID */
  id: number;
};

export type SystemDictTypeDetailIdUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaDictTypeOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictTypeListUsingGetParams = {
  /** 当前页码 */
  page_no?: number;
  /** 每页数量 */
  page_size?: number;
  /** 排序字段,格式:[{'field1': 'asc'}, {'field2': 'desc'}] */
  order_by?: string | null;
  /** 字典名称 */
  dict_name?: string | null;
  /** 字典类型 */
  dict_type?: string | null;
  /** 状态（0正常 1停用） */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
};

export type SystemDictTypeListUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListDictTypeOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictTypeOpenApiDeleteUsingDeleteBody = number[];

export type SystemDictTypeOpenApiDeleteUsingDeleteResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictTypeOpenApiExportUsingPostParams = {
  /** 字典名称 */
  dict_name?: string | null;
  /** 字典类型 */
  dict_type?: string | null;
  /** 状态（0正常 1停用） */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
};

export type SystemDictTypeOpenApiExportUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictTypeOptionselectUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListDictTypeOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemDictTypeUpdateIdUsingPutParams = {
  /** 字典类型ID */
  id: number;
};

export type SystemDictTypeUpdateIdUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaDictTypeOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemLogDetailIdUsingGetParams = {
  /** 操作日志ID */
  id: number;
};

export type SystemLogDetailIdUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaOperationLogOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemLogListUsingGetParams = {
  /** 当前页码 */
  page_no?: number;
  /** 每页数量 */
  page_size?: number;
  /** 排序字段,格式:[{'field1': 'asc'}, {'field2': 'desc'}] */
  order_by?: string | null;
  /** 日志类型(1:登录日志, 2:操作日志) */
  type?: number | null;
  /** 请求路径 */
  request_path?: string | null;
  /** 请求方法 */
  request_method?: string | null;
  /** 请求IP */
  request_ip?: string | null;
  /** 响应状态码 */
  response_code?: number | null;
  /** 描述 */
  description?: string | null;
  /** 是否启用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
  /** 创建人 */
  created_id?: number | null;
  /** 更新人 */
  updated_id?: number | null;
  /** 操作人账号 */
  username?: string | null;
  /** 操作人手机号 */
  mobile?: string | null;
  /** 登录平台 */
  login_platform?: string | null;
};

export type SystemLogListUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListOperationLogOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemLogOpenApiDeleteUsingDeleteBody = number[];

export type SystemLogOpenApiDeleteUsingDeleteResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemLogOpenApiExportUsingPostParams = {
  /** 日志类型(1:登录日志, 2:操作日志) */
  type?: number | null;
  /** 请求路径 */
  request_path?: string | null;
  /** 请求方法 */
  request_method?: string | null;
  /** 请求IP */
  request_ip?: string | null;
  /** 响应状态码 */
  response_code?: number | null;
  /** 描述 */
  description?: string | null;
  /** 是否启用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
  /** 创建人 */
  created_id?: number | null;
  /** 更新人 */
  updated_id?: number | null;
  /** 操作人账号 */
  username?: string | null;
  /** 操作人手机号 */
  mobile?: string | null;
  /** 登录平台 */
  login_platform?: string | null;
};

export type SystemLogOpenApiExportUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemMenuAvailableSettingUsingPatchResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemMenuCreateUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaMenuOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemMenuDetailIdUsingGetParams = {
  /** 菜单ID */
  id: number;
};

export type SystemMenuDetailIdUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaMenuOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemMenuOpenApiDeleteUsingDeleteBody = number[];

export type SystemMenuOpenApiDeleteUsingDeleteResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemMenuTreeUsingGetParams = {
  /** 菜单名称 */
  name?: string | null;
  /** 路由地址 */
  route_path?: string | null;
  /** 组件路径 */
  component_path?: string | null;
  /** 菜单类型(1:目录 2:菜单 3:按钮 4:外链) */
  type?: 1 | 2 | 3 | 4 | null;
  /** 权限标识 */
  permission?: string | null;
  /** 描述 */
  description?: string | null;
  /** 是否启用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
  /** 创建人 */
  created_id?: number | null;
  /** 更新人 */
  updated_id?: number | null;
  /** 管理端 Tab：pc=桌面端菜单 app=移动端菜单；不传则不过滤终端 */
  menu_client?: 'pc' | 'app' | null;
};

export type SystemMenuTreeUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListMenuOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemMenuUpdateIdUsingPutParams = {
  /** 菜单ID */
  id: number;
};

export type SystemMenuUpdateIdUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaMenuOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemNoticeAvailableSettingUsingPatchResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemNoticeAvailableUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListNoticeOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemNoticeCreateUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoticeOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemNoticeDetailIdUsingGetParams = {
  /** 公告ID */
  id: number;
};

export type SystemNoticeDetailIdUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoticeOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemNoticeListUsingGetParams = {
  /** 当前页码 */
  page_no?: number;
  /** 每页数量 */
  page_size?: number;
  /** 排序字段,格式:[{'field1': 'asc'}, {'field2': 'desc'}] */
  order_by?: string | null;
  /** 公告标题 */
  notice_title?: string | null;
  /** 公告类型 */
  notice_type?: string | null;
  /** 描述 */
  description?: string | null;
  /** 是否启用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
  /** 创建人 */
  created_id?: number | null;
  /** 更新人 */
  updated_id?: number | null;
};

export type SystemNoticeListUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListNoticeOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemNoticeOpenApiDeleteUsingDeleteBody = number[];

export type SystemNoticeOpenApiDeleteUsingDeleteResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemNoticeOpenApiExportUsingPostParams = {
  /** 公告标题 */
  notice_title?: string | null;
  /** 公告类型 */
  notice_type?: string | null;
  /** 描述 */
  description?: string | null;
  /** 是否启用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
  /** 创建人 */
  created_id?: number | null;
  /** 更新人 */
  updated_id?: number | null;
};

export type SystemNoticeOpenApiExportUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemNoticeUpdateIdUsingPutParams = {
  /** 公告ID */
  id: number;
};

export type SystemNoticeUpdateIdUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoticeOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemParamCreateUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaParamsOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemParamDetailIdUsingGetParams = {
  /** 参数ID */
  id: number;
};

export type SystemParamDetailIdUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaParamsOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemParamInfoUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListParamsOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemParamKeyConfigKeyUsingGetParams = {
  /** 配置键 */
  config_key: string;
};

export type SystemParamKeyConfigKeyUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaParamsOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemParamListUsingGetParams = {
  /** 当前页码 */
  page_no?: number;
  /** 每页数量 */
  page_size?: number;
  /** 排序字段,格式:[{'field1': 'asc'}, {'field2': 'desc'}] */
  order_by?: string | null;
  /** 配置名称 */
  config_name?: string | null;
  /** 配置键名 */
  config_key?: string | null;
  /** 系统内置((True:是 False:否)) */
  config_type?: boolean | null;
  /** 描述 */
  description?: string | null;
  /** 是否启用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
};

export type SystemParamListUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListParamsOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemParamOpenApiDeleteUsingDeleteBody = number[];

export type SystemParamOpenApiDeleteUsingDeleteResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaParamsOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemParamOpenApiExportUsingPostParams = {
  /** 配置名称 */
  config_name?: string | null;
  /** 配置键名 */
  config_key?: string | null;
  /** 系统内置((True:是 False:否)) */
  config_type?: boolean | null;
  /** 描述 */
  description?: string | null;
  /** 是否启用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
};

export type SystemParamOpenApiExportUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemParamUpdateIdUsingPutParams = {
  /** 参数ID */
  id: number;
};

export type SystemParamUpdateIdUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaParamsOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemParamUploadUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemParamValueConfigKeyUsingGetParams = {
  /** 配置键 */
  config_key: string;
};

export type SystemParamValueConfigKeyUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaParamsOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemPositionAvailableSettingUsingPatchResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemPositionCreateUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaPositionOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemPositionDetailIdUsingGetParams = {
  /** 岗位ID */
  id: number;
};

export type SystemPositionDetailIdUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaPositionOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemPositionListUsingGetParams = {
  /** 当前页码 */
  page_no?: number;
  /** 每页数量 */
  page_size?: number;
  /** 排序字段,格式:[{'field1': 'asc'}, {'field2': 'desc'}] */
  order_by?: string | null;
  /** 岗位名称 */
  name?: string | null;
  /** 描述 */
  description?: string | null;
  /** 是否启用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
  /** 创建人 */
  created_id?: number | null;
  /** 更新人 */
  updated_id?: number | null;
};

export type SystemPositionListUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListPositionOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemPositionOpenApiDeleteUsingDeleteBody = number[];

export type SystemPositionOpenApiDeleteUsingDeleteResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemPositionOpenApiExportUsingPostParams = {
  /** 岗位名称 */
  name?: string | null;
  /** 描述 */
  description?: string | null;
  /** 是否启用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
  /** 创建人 */
  created_id?: number | null;
  /** 更新人 */
  updated_id?: number | null;
};

export type SystemPositionOpenApiExportUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemPositionUpdateIdUsingPutParams = {
  /** 岗位ID */
  id: number;
};

export type SystemPositionUpdateIdUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaPositionOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemRoleAvailableSettingUsingPatchResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemRoleCreateUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaRoleOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemRoleDetailIdUsingGetParams = {
  /** 角色ID */
  id: number;
};

export type SystemRoleDetailIdUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaRoleOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemRoleListUsingGetParams = {
  /** 当前页码 */
  page_no?: number;
  /** 每页数量 */
  page_size?: number;
  /** 排序字段,格式:[{'field1': 'asc'}, {'field2': 'desc'}] */
  order_by?: string | null;
  /** 角色名称 */
  name?: string | null;
  /** 描述 */
  description?: string | null;
  /** 是否启用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
};

export type SystemRoleListUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListRoleOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemRoleOpenApiDeleteUsingDeleteBody = number[];

export type SystemRoleOpenApiDeleteUsingDeleteResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemRoleOpenApiExportUsingPostParams = {
  /** 角色名称 */
  name?: string | null;
  /** 描述 */
  description?: string | null;
  /** 是否启用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
};

export type SystemRoleOpenApiExportUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemRolePermissionSettingUsingPatchResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemRoleUpdateIdUsingPutParams = {
  /** 角色ID */
  id: number;
};

export type SystemRoleUpdateIdUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaRoleOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemTenantAvailableSettingUsingPatchResponses = {
  /**
   * 成功
   */
  200: unknown;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemTenantCreateUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaTenantOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemTenantDetailIdUsingGetParams = {
  /** 租户ID */
  id: number;
};

export type SystemTenantDetailIdUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaTenantOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemTenantListUsingGetParams = {
  /** 当前页码 */
  page_no?: number;
  /** 每页数量 */
  page_size?: number;
  /** 排序字段,格式:[{'field1': 'asc'}, {'field2': 'desc'}] */
  order_by?: string | null;
  /** 租户名称 */
  name?: string | null;
  /** 租户编码 */
  code?: string | null;
  /** 状态 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
};

export type SystemTenantListUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaDict_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemTenantOpenApiDeleteUsingDeleteBody = number[];

export type SystemTenantOpenApiDeleteUsingDeleteResponses = {
  /**
   * 成功
   */
  200: unknown;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemTenantUpdateIdUsingPutParams = {
  /** 租户ID */
  id: number;
};

export type SystemTenantUpdateIdUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaTenantOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserAvailableSettingUsingPatchResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserCreateUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaUserOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserCurrentAvatarUploadUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaUserOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserCurrentInfoUpdateUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaUserOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserCurrentInfoUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaUserOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserCurrentPasswordChangeUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaUserOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserDetailIdUsingGetParams = {
  /** 用户ID */
  id: number;
};

export type SystemUserDetailIdUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaUserOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserForgetPasswordUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaUserOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserListUsingGetParams = {
  /** 当前页码 */
  page_no?: number;
  /** 每页数量 */
  page_size?: number;
  /** 排序字段,格式:[{'field1': 'asc'}, {'field2': 'desc'}] */
  order_by?: string | null;
  /** 用户名 */
  username?: string | null;
  /** 名称 */
  name?: string | null;
  /** 手机号 */
  mobile?: string | null;
  /** 邮箱 */
  email?: string | null;
  /** 部门ID */
  dept_id?: number | null;
  /** 租户ID（仅平台管理员可筛选） */
  tenant_id?: number | null;
  /** 是否可用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
  /** 创建人 */
  created_id?: number | null;
  /** 更新人 */
  updated_id?: number | null;
};

export type SystemUserListUsingGetResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaListUserOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserOpenApiDeleteUsingDeleteBody = number[];

export type SystemUserOpenApiDeleteUsingDeleteResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserOpenApiExportUsingPostParams = {
  /** 当前页码 */
  page_no?: number;
  /** 每页数量 */
  page_size?: number;
  /** 排序字段,格式:[{'field1': 'asc'}, {'field2': 'desc'}] */
  order_by?: string | null;
  /** 用户名 */
  username?: string | null;
  /** 名称 */
  name?: string | null;
  /** 手机号 */
  mobile?: string | null;
  /** 邮箱 */
  email?: string | null;
  /** 部门ID */
  dept_id?: number | null;
  /** 租户ID（仅平台管理员可筛选） */
  tenant_id?: number | null;
  /** 是否可用 */
  status?: string | null;
  /** 创建时间范围 */
  created_time?: string[] | null;
  /** 更新时间范围 */
  updated_time?: string[] | null;
  /** 创建人 */
  created_id?: number | null;
  /** 更新人 */
  updated_id?: number | null;
};

export type SystemUserOpenApiExportUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserOpenApiImportDataUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserOpenApiImportTemplateUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaNoneType_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserRegisterUsingPostResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaUserOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserResetPasswordUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaUserOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type SystemUserUpdateIdUsingPutParams = {
  /** 用户ID */
  id: number;
};

export type SystemUserUpdateIdUsingPutResponses = {
  /**
   * 成功
   */
  200: ResponseSchemaUserOutSchema_;
  /**
   * 请求参数错误
   */
  400: unknown;
  /**
   * 未认证
   */
  401: unknown;
  /**
   * 未授权
   */
  403: unknown;
  /**
   * 资源不存在
   */
  404: unknown;
  /**
   * 请求参数验证错误
   */
  422: unknown;
  /**
   * 服务器内部错误
   */
  500: unknown;
};

export type TenantCreateSchema = {
  /** Name 租户名称 */
  name: string;
  /** Code 租户编码 */
  code: string;
  /** Status 状态(0:正常 1:禁用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Start Time 开始时间 */
  start_time?: string | null;
  /** End Time 结束时间 */
  end_time?: string | null;
};

export type TenantOutSchema = {
  /** Id 主键ID */
  id?: number | null;
  /** Uuid UUID */
  uuid?: string | null;
  /** Status 状态(0:正常 1:禁用) */
  status?: string;
  /** Description 描述 */
  description?: string | null;
  /** Created Time 创建时间 */
  created_time?: string | null;
  /** Updated Time 更新时间 */
  updated_time?: string | null;
  /** Is Deleted 是否已删除 */
  is_deleted?: boolean;
  /** Deleted Time 删除时间 */
  deleted_time?: string | null;
  /** Name 租户名称 */
  name: string;
  /** Code 租户编码 */
  code: string;
  /** Start Time 开始时间 */
  start_time?: string | null;
  /** End Time 结束时间 */
  end_time?: string | null;
};

export type TenantUpdateSchema = {
  /** Name 租户名称 */
  name?: string | null;
  /** Code 租户编码 */
  code?: string | null;
  /** Status 状态(0:正常 1:禁用) */
  status?: string | null;
  /** Description 描述 */
  description?: string | null;
  /** Start Time 开始时间 */
  start_time?: string | null;
  /** End Time 结束时间 */
  end_time?: string | null;
};

export type UserChangePasswordSchema = {
  /** Old Password 旧密码 */
  old_password: string;
  /** New Password 新密码 */
  new_password: string;
};

export type UserCreateSchema = {
  /** Name 名称 */
  name?: string | null;
  /** Mobile 手机号 */
  mobile?: string | null;
  /** Email 邮箱 */
  email?: string | null;
  /** Gender 性别 */
  gender?: string | null;
  /** Avatar 头像 */
  avatar?: string | null;
  /** Id Card 身份证号 */
  id_card?: string | null;
  /** Username 用户名 */
  username?: string | null;
  /** Password 密码哈希值 */
  password?: string | null;
  /** Status 是否可用 */
  status?: string;
  /** Description 备注 */
  description?: string | null;
  /** Is Superuser 是否超管 */
  is_superuser?: boolean | null;
  /** Dept Id 部门ID */
  dept_id?: number | null;
  /** Tenant Id 租户ID，仅平台管理员创建时可指定 */
  tenant_id?: number | null;
  /** Role Ids 角色ID */
  role_ids?: number[] | null;
  /** Position Ids 岗位ID */
  position_ids?: number[] | null;
};

export type UserForgetPasswordSchema = {
  /** Username 用户名 */
  username: string;
  /** New Password 新密码 */
  new_password: string;
  /** Mobile 手机号 */
  mobile?: string | null;
};

export type UserOutSchema = {
  /** 租户信息 */
  tenant?: CommonSchema | null;
  /** Created Id 创建人ID */
  created_id?: number | null;
  /** 创建人信息 */
  created_by?: CommonSchema | null;
  /** Updated Id 更新人ID */
  updated_id?: number | null;
  /** 更新人信息 */
  updated_by?: CommonSchema | null;
  /** Deleted Id 删除人ID */
  deleted_id?: number | null;
  /** 删除人信息 */
  deleted_by?: CommonSchema | null;
  /** Id 主键ID */
  id?: number | null;
  /** Uuid UUID */
  uuid?: string | null;
  /** Status 是否可用 */
  status?: string;
  /** Description 备注 */
  description?: string | null;
  /** Created Time 创建时间 */
  created_time?: string | null;
  /** Updated Time 更新时间 */
  updated_time?: string | null;
  /** Is Deleted 是否已删除 */
  is_deleted?: boolean;
  /** Deleted Time 删除时间 */
  deleted_time?: string | null;
  /** Name 名称 */
  name?: string | null;
  /** Mobile 手机号 */
  mobile?: string | null;
  /** Email 邮箱 */
  email?: string | null;
  /** Gender 性别 */
  gender?: string | null;
  /** Avatar 头像 */
  avatar?: string | null;
  /** Id Card 身份证号 */
  id_card?: string | null;
  /** Username 用户名 */
  username?: string | null;
  /** Is Superuser 是否超管 */
  is_superuser?: boolean | null;
  /** Dept Id 部门ID */
  dept_id?: number | null;
  /** Role Ids 角色ID */
  role_ids?: number[] | null;
  /** Position Ids 岗位ID */
  position_ids?: number[] | null;
  /** Last Login 最后登录时间 */
  last_login?: string | null;
  /** Gitee Login Gitee登录 */
  gitee_login?: string | null;
  /** Github Login Github登录 */
  github_login?: string | null;
  /** Wx Login 微信登录 */
  wx_login?: string | null;
  /** Qq Login QQ登录 */
  qq_login?: string | null;
  /** Dept Name 部门名称 */
  dept_name?: string | null;
  /** 部门 */
  dept?: CommonSchema | null;
  /** Positions 岗位 */
  positions?: CommonSchema[] | null;
  /** Roles 角色 */
  roles?: RoleOutSchema[] | null;
  /** Menus 菜单 */
  menus?: MenuOutSchema[] | null;
};

export type UserRegisterSchema = {
  /** Name 名称 */
  name?: string | null;
  /** Mobile 手机号 */
  mobile?: string | null;
  /** Username 账号 */
  username: string;
  /** Password 密码哈希值 */
  password: string;
  /** Role Ids 角色ID */
  role_ids?: number[] | null;
  /** Created Id 创建人ID */
  created_id?: number | null;
  /** Description 备注 */
  description?: string | null;
};

export type UserUpdateSchema = {
  /** Name 名称 */
  name?: string | null;
  /** Mobile 手机号 */
  mobile?: string | null;
  /** Email 邮箱 */
  email?: string | null;
  /** Gender 性别 */
  gender?: string | null;
  /** Avatar 头像 */
  avatar?: string | null;
  /** Id Card 身份证号 */
  id_card?: string | null;
  /** Username 用户名 */
  username?: string | null;
  /** Password 密码哈希值 */
  password?: string | null;
  /** Status 是否可用 */
  status?: string;
  /** Description 备注 */
  description?: string | null;
  /** Is Superuser 是否超管 */
  is_superuser?: boolean | null;
  /** Dept Id 部门ID */
  dept_id?: number | null;
  /** Tenant Id 租户ID，仅平台管理员创建时可指定 */
  tenant_id?: number | null;
  /** Role Ids 角色ID */
  role_ids?: number[] | null;
  /** Position Ids 岗位ID */
  position_ids?: number[] | null;
  /** Last Login 最后登录时间 */
  last_login?: string | null;
};

export type WxLoginSchema = {
  /** Code uni.login 返回的临时登录凭证 code */
  code: string;
  /** Nickname 用户昵称（可选） */
  nickname?: string | null;
  /** Avatar 头像 URL（可选） */
  avatar?: string | null;
};

export type WxPhoneLoginSchema = {
  /** Code getPhoneNumber 回调返回的动态令牌 code */
  code: string;
};

export type WxQrCodeOutSchema = {
  /** Url 小程序码图片（base64 data URI，可直接作 img src） */
  url: string;
};

export type WxQrCodeSchema = {
  /** Scene 场景参数（如 invite=xxx，最大32字符） */
  scene: string;
  /** Page 小程序页面路径，为空则默认主页 */
  page?: string | null;
  /** Width 小程序码宽度（px） */
  width?: number;
};
