import { defineConfig } from 'openapi-ts-request'

export default defineConfig([
  {
    describe: 'fastapiadmin-backend',
    // 真实后端 OpenAPI 快照（本地文件，离线可生成）。
    // 后端接口更新后刷新：curl -o src/api/openapi/openapi.json http://127.0.0.1:6100/openapi.json
    schemaPath: './src/api/openapi/openapi.json',
    serversPath: './src/api/openapi',
    // 选择性拉取：按业务域 tag 过滤（改数组后重跑 pnpm openapi）。
    // 全部 30 个域见 openapi.json 的 tags；也可换 includePaths: [/^\/system\/auth/]
    // 追加新域：监控运维(在线用户/服务器监控/缓存监控/调度器监控/健康检查/节点/资源管理/文件管理)、
    //          AI(AI聊天会话管理/AI模型管理/AI供应商管理)、存储(存储浏览/存储节点管理/
    //          传输任务管理/存储工作流管理)、应用(应用管理/代码生成模块/示例模块/示例01模块)
    includeTags: [
      '认证授权',
      '用户管理',
      '角色管理',
      '菜单管理',
      '部门管理',
      '岗位管理',
      '租户管理',
      '日志管理',
      '参数管理',
      '字典管理',
      '公告通知',
    ],
    requestLibPath: `import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';`,
    requestOptionsType: 'CustomRequestOptions_',
    isGenReactQuery: false,
    reactQueryMode: 'vue',
    isGenJavaScript: false,
  },
])
