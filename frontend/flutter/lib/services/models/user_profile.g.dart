// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  index: (json['index'] as num?)?.toInt(),
  id: (json['id'] as num?)?.toInt(),
  username: json['username'] as String?,
  name: json['name'] as String?,
  nickname: json['nickname'] as String?,
  phone: json['phone'] as String?,
  merchantId: (json['merchant_id'] as num?)?.toInt(),
  avatar: json['avatar'] as String?,
  email: json['email'] as String?,
  mobile: json['mobile'] as String?,
  gender: json['gender'] as String?,
  password: json['password'] as String?,
  menus: (json['menus'] as List<dynamic>?)
      ?.map((e) => MenuTable.fromJson(e as Map<String, dynamic>))
      .toList(),
  dept: json['dept'] == null
      ? null
      : DeptTreeType.fromJson(json['dept'] as Map<String, dynamic>),
  deptId: (json['dept_id'] as num?)?.toInt(),
  deptName: json['dept_name'] as String?,
  roles: (json['roles'] as List<dynamic>?)
      ?.map((e) => RoleSelectorType.fromJson(e as Map<String, dynamic>))
      .toList(),
  roleNames: (json['roleNames'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  roleIds: (json['role_ids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  positions: (json['positions'] as List<dynamic>?)
      ?.map((e) => PositionSelectorType.fromJson(e as Map<String, dynamic>))
      .toList(),
  positionNames: (json['positionNames'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  positionIds: (json['position_ids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  isSuperuser: json['is_superuser'] as bool?,
  status: json['status'] as String?,
  description: json['description'] as String?,
  lastLogin: json['last_login'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  creator: json['creator'] == null
      ? null
      : CreatorType.fromJson(json['creator'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'index': instance.index,
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'nickname': instance.nickname,
      'phone': instance.phone,
      'merchant_id': instance.merchantId,
      'avatar': instance.avatar,
      'email': instance.email,
      'mobile': instance.mobile,
      'gender': instance.gender,
      'password': instance.password,
      'menus': instance.menus,
      'dept': instance.dept,
      'dept_id': instance.deptId,
      'dept_name': instance.deptName,
      'roles': instance.roles,
      'roleNames': instance.roleNames,
      'role_ids': instance.roleIds,
      'positions': instance.positions,
      'positionNames': instance.positionNames,
      'position_ids': instance.positionIds,
      'is_superuser': instance.isSuperuser,
      'status': instance.status,
      'description': instance.description,
      'last_login': instance.lastLogin,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'creator': instance.creator,
    };

MenuTable _$MenuTableFromJson(Map<String, dynamic> json) => MenuTable(
  index: (json['index'] as num?)?.toInt(),
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  type: (json['type'] as num?)?.toInt(),
  icon: json['icon'] as String?,
  order: (json['order'] as num?)?.toInt(),
  permission: json['permission'] as String?,
  routeName: json['route_name'] as String?,
  routePath: json['route_path'] as String?,
  componentPath: json['component_path'] as String?,
  redirect: json['redirect'] as String?,
  parentId: (json['parent_id'] as num?)?.toInt(),
  parentName: json['parent_name'] as String?,
  keepAlive: json['keep_alive'] as bool?,
  hidden: json['hidden'] as bool?,
  alwaysShow: json['always_show'] as bool?,
  title: json['title'] as String?,
  params: (json['params'] as List<dynamic>?)
      ?.map((e) => MenuParam.fromJson(e as Map<String, dynamic>))
      .toList(),
  affix: json['affix'] as bool?,
  status: json['status'] as String?,
  description: json['description'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => MenuTable.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MenuTableToJson(MenuTable instance) => <String, dynamic>{
  'index': instance.index,
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'icon': instance.icon,
  'order': instance.order,
  'permission': instance.permission,
  'route_name': instance.routeName,
  'route_path': instance.routePath,
  'component_path': instance.componentPath,
  'redirect': instance.redirect,
  'parent_id': instance.parentId,
  'parent_name': instance.parentName,
  'keep_alive': instance.keepAlive,
  'hidden': instance.hidden,
  'always_show': instance.alwaysShow,
  'title': instance.title,
  'params': instance.params,
  'affix': instance.affix,
  'status': instance.status,
  'description': instance.description,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'children': instance.children,
};

MenuParam _$MenuParamFromJson(Map<String, dynamic> json) =>
    MenuParam(key: json['key'] as String?, value: json['value'] as String?);

Map<String, dynamic> _$MenuParamToJson(MenuParam instance) => <String, dynamic>{
  'key': instance.key,
  'value': instance.value,
};

DeptTreeType _$DeptTreeTypeFromJson(Map<String, dynamic> json) => DeptTreeType(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  parentId: (json['parent_id'] as num?)?.toInt(),
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => DeptTreeType.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DeptTreeTypeToJson(DeptTreeType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parent_id': instance.parentId,
      'children': instance.children,
    };

RoleSelectorType _$RoleSelectorTypeFromJson(Map<String, dynamic> json) =>
    RoleSelectorType(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      status: json['status'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$RoleSelectorTypeToJson(RoleSelectorType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'description': instance.description,
    };

PositionSelectorType _$PositionSelectorTypeFromJson(
  Map<String, dynamic> json,
) => PositionSelectorType(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  status: json['status'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$PositionSelectorTypeToJson(
  PositionSelectorType instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': instance.status,
  'description': instance.description,
};

CreatorType _$CreatorTypeFromJson(Map<String, dynamic> json) => CreatorType(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  username: json['username'] as String?,
  avatar: json['avatar'] as String?,
  mobile: json['mobile'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$CreatorTypeToJson(CreatorType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'avatar': instance.avatar,
      'mobile': instance.mobile,
      'email': instance.email,
    };
