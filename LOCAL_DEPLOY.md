# YR-Hrms 本地 PostgreSQL 部署

已采用 PostgreSQL 17 + Redis 7（Docker）以及本机 Python 3.14.7 / Node 的开发模式。

- 管理后台：http://127.0.0.1:6110/web/
- Swagger：http://127.0.0.1:6100/api/v1/docs
- 初始管理员：`admin` / `123456`，登录需要填写图片中的算术验证码。
- PostgreSQL：`127.0.0.1:55432`，数据库和用户均为 `yr_hrms`。
- 数据库密码见 `backend/env/.env`，Compose 密码在 `docker/.env.local`。
- Redis：`127.0.0.1:56379`，独立容器。

在项目根目录执行：

```bash
bash local-deploy.sh start
bash local-deploy.sh status
bash local-deploy.sh stop
```

首次启动会自动创建 ORM 表和导入插件种子数据，当前已完成。容器数据保存在 Docker 命名卷中，停止不会删除数据。启动需要 Docker Desktop 运行；前后端后台进程日志位于 `.local/backend.log` 和 `.local/web.log`，应用日志位于 `backend/logs/`。

这套配置绑定本地回环地址。重启电脑后运行启动命令。AI 功能和第三方登录需要另行配置对应服务密钥。

项目目录：`YR-Hrms`；GitHub 仓库：<https://github.com/Yang180x/YR-Hrms>。技术标识使用 `yr-hrms` / `yr_hrms`，Flutter 包名为 `yr_hrms_mobile`。
