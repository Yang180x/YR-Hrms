# module_system/ticket — 工单管理

## 模块定位

用户建议/缺陷反馈工单：状态机流转（0=待处理 1=处理中 2=已完成 3=已关闭，
守卫规则限定创建人/处理人/超管的操作边界）、指派处理人、评论、统计与导出。
富文本字段（ticket_content/comment content）在 schema 层过 XSS 清洗。

## 入口

| 入口类型   | 路径                              | 说明                                          |
| ---------- | --------------------------------- | --------------------------------------------- |
| HTTP 路由  | `controller.py` → `TicketRouter`  | 容器前缀 `/system/ticket`，共 10 条（目录扫描挂载） |
| ORM 模型   | `model.py` → `TicketModel` / `TicketCommentModel` | 表 `sys_ticket` / `sys_ticket_comment` |
| 业务实现   | `service.py` / `crud.py` / `schema.py` | 状态机守卫为模块级纯函数 `validate_status_transition` |

路由：`GET /system/ticket/stats`、`GET /system/ticket/list`、
`GET /system/ticket/detail/{id}`、`POST /system/ticket/create`、
`PUT /system/ticket/update/{id}`、`PUT /system/ticket/batch`、
`DELETE /system/ticket/delete`、`POST /system/ticket/export`、
`GET|POST /system/ticket/{ticket_id}/comments`。

## 依赖

- 内核槽位：无。
- 其它插件：`system`（`user/crud.py` 的 `UserCRUD` 用于指派人存在性校验）。
- 第三方：无（Excel 导出走内核 `ExcelUtil`）。

## 删除影响

删除本子模块后：

- `sys_ticket` / `sys_ticket_comment` 表失去读写方（表与数据残留，需手动 DROP）；
- `app/common/enums.py` 的 `TicketTypeEnum` 成为无消费者死代码；
- 管理后台「工单管理」菜单（种子 `sys_menu` 中 `module_system:ticket:*` 权限组）
  点击后 404，需同步清理菜单种子；
- `/system/ticket/*` 全部路由 404，路由基线需重生成（少 10 条）。
