# module_system/versions — 版本管理

## 模块定位

平台级版本发布管理：版本号唯一、富文本更新内容、状态流转（0=草稿 1=已发布 2=已回滚）、
`require_re_login` 标记。数据供管理后台维护，`GET /versions/published` 对外提供
已发布版本列表（更新日志展示）。

## 入口

| 入口类型   | 路径                             | 说明                                       |
| ---------- | -------------------------------- | ------------------------------------------ |
| HTTP 路由  | `controller.py` → `VersionRouter` | 容器前缀 `/system/versions`，共 7 条（目录扫描挂载） |
| ORM 模型   | `model.py` → `VersionModel`      | 表 `sys_version`（status 为 Integer 覆盖 mixin String） |
| 业务实现   | `service.py` / `crud.py` / `schema.py` | 状态枚举校验在 `VersionStatusSchema` |

路由：`GET /system/versions/list`、`GET /system/versions/published`、
`GET /system/versions/detail/{id}`、`POST /system/versions/create`、
`PUT /system/versions/update/{id}`、`DELETE /system/versions/delete`、
`PUT /system/versions/{id}/status`。

## 依赖

- 内核槽位：无。
- 其它插件：无（仅内核 `CRUDBase` / `AuthPermission` / `xss_util`）。
- 第三方：无。

## 删除影响

删除本子模块后：

- `sys_version` 表失去读写方（表与数据残留，需手动 DROP）；
- 管理后台「版本管理」菜单（种子 `sys_menu` 中 `module_system:version:*` 权限组）
  点击后 404，需同步清理菜单种子；
- `/system/versions/*` 全部路由 404，路由基线 `tests/fixtures/routes_baseline.json`
  需重生成（少 7 条）。
