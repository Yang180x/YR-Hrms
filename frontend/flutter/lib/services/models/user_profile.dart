import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

// ============================================================
// UserProfile — 登录用户信息
// 参照 UniApp UserInfo 接口定义
// ============================================================

@JsonSerializable()
class UserProfile {
  int? index;
  int? id;
  String? username;
  String? name;
  String? nickname;
  String? phone;
  @JsonKey(name: 'merchant_id')
  int? merchantId;
  String? avatar;
  String? email;
  String? mobile;
  String? gender;
  String? password;
  List<MenuTable>? menus;
  DeptTreeType? dept;
  @JsonKey(name: 'dept_id')
  int? deptId;
  @JsonKey(name: 'dept_name')
  String? deptName;
  List<RoleSelectorType>? roles;
  List<String>? roleNames;
  @JsonKey(name: 'role_ids')
  List<int>? roleIds;
  List<PositionSelectorType>? positions;
  List<String>? positionNames;
  @JsonKey(name: 'position_ids')
  List<int>? positionIds;
  @JsonKey(name: 'is_superuser')
  bool? isSuperuser;
  String? status;
  String? description;
  @JsonKey(name: 'last_login')
  String? lastLogin;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  CreatorType? creator;

  UserProfile({
    this.index,
    this.id,
    this.username,
    this.name,
    this.nickname,
    this.phone,
    this.merchantId,
    this.avatar,
    this.email,
    this.mobile,
    this.gender,
    this.password,
    this.menus,
    this.dept,
    this.deptId,
    this.deptName,
    this.roles,
    this.roleNames,
    this.roleIds,
    this.positions,
    this.positionNames,
    this.positionIds,
    this.isSuperuser,
    this.status,
    this.description,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.creator,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

// ============================================================
// MenuTable — 菜单表
// ============================================================

@JsonSerializable()
class MenuTable {
  int? index;
  int? id;
  String? name;
  int? type;
  String? icon;
  int? order;
  String? permission;
  @JsonKey(name: 'route_name')
  String? routeName;
  @JsonKey(name: 'route_path')
  String? routePath;
  @JsonKey(name: 'component_path')
  String? componentPath;
  String? redirect;
  @JsonKey(name: 'parent_id')
  int? parentId;
  @JsonKey(name: 'parent_name')
  String? parentName;
  @JsonKey(name: 'keep_alive')
  bool? keepAlive;
  bool? hidden;
  @JsonKey(name: 'always_show')
  bool? alwaysShow;
  String? title;
  List<MenuParam>? params;
  bool? affix;
  String? status;
  String? description;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  List<MenuTable>? children;

  MenuTable({
    this.index,
    this.id,
    this.name,
    this.type,
    this.icon,
    this.order,
    this.permission,
    this.routeName,
    this.routePath,
    this.componentPath,
    this.redirect,
    this.parentId,
    this.parentName,
    this.keepAlive,
    this.hidden,
    this.alwaysShow,
    this.title,
    this.params,
    this.affix,
    this.status,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.children,
  });

  factory MenuTable.fromJson(Map<String, dynamic> json) =>
      _$MenuTableFromJson(json);

  Map<String, dynamic> toJson() => _$MenuTableToJson(this);
}

@JsonSerializable()
class MenuParam {
  String? key;
  String? value;

  MenuParam({this.key, this.value});

  factory MenuParam.fromJson(Map<String, dynamic> json) =>
      _$MenuParamFromJson(json);

  Map<String, dynamic> toJson() => _$MenuParamToJson(this);
}

// ============================================================
// DeptTreeType — 部门树
// ============================================================

@JsonSerializable()
class DeptTreeType {
  int? id;
  String? name;
  @JsonKey(name: 'parent_id')
  int? parentId;
  List<DeptTreeType>? children;

  DeptTreeType({this.id, this.name, this.parentId, this.children});

  factory DeptTreeType.fromJson(Map<String, dynamic> json) =>
      _$DeptTreeTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DeptTreeTypeToJson(this);
}

// ============================================================
// RoleSelectorType — 角色选择器
// ============================================================

@JsonSerializable()
class RoleSelectorType {
  int? id;
  String? name;
  String? status;
  String? description;

  RoleSelectorType({this.id, this.name, this.status, this.description});

  factory RoleSelectorType.fromJson(Map<String, dynamic> json) =>
      _$RoleSelectorTypeFromJson(json);

  Map<String, dynamic> toJson() => _$RoleSelectorTypeToJson(this);
}

// ============================================================
// PositionSelectorType — 职位选择器
// ============================================================

@JsonSerializable()
class PositionSelectorType {
  int? id;
  String? name;
  String? status;
  String? description;

  PositionSelectorType({this.id, this.name, this.status, this.description});

  factory PositionSelectorType.fromJson(Map<String, dynamic> json) =>
      _$PositionSelectorTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PositionSelectorTypeToJson(this);
}

// ============================================================
// CreatorType — 创建人信息
// ============================================================

@JsonSerializable()
class CreatorType {
  int? id;
  String? name;
  String? username;
  String? avatar;
  String? mobile;
  String? email;

  CreatorType({
    this.id,
    this.name,
    this.username,
    this.avatar,
    this.mobile,
    this.email,
  });

  factory CreatorType.fromJson(Map<String, dynamic> json) =>
      _$CreatorTypeFromJson(json);

  Map<String, dynamic> toJson() => _$CreatorTypeToJson(this);
}
