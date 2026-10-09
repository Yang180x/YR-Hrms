/// API 模块 barrel export
///
/// 所有 API 类继承 [BaseApi] 使用通用请求方法：
/// - [BaseApi.get] / [BaseApi.post] / [BaseApi.put] — 基础请求
/// - [BaseApi.listPage] — 分页列表快捷查询
///
/// 可用 API：
/// - [AuthApi] — 登录/登出/SM2 公钥
/// - [UserApi] — 当前用户资料
/// - [UserAdminApi] — 后台用户管理
/// - [SystemApi] — 菜单树
/// - [NoticeApi] / [DeptApi] / [RoleApi] / [PositionApi] — 分页列表
library;

export 'base_api.dart';
export 'auth_api.dart';
export 'user_api.dart';
export 'user_admin_api.dart';
export 'system_api.dart';
export 'notice_api.dart';
export 'dept_api.dart';
export 'role_api.dart';
export 'position_api.dart';
