# 请求库（http 模块）

## 统一出口

外部（`api/` `pages/` `store/` `service/` 等）**一律从 `@/http` 导入**，禁止直连
`@/http/*` 子路径 —— 由 eslint `no-restricted-imports` 规则提示（见 `eslint.config.mjs`）。

```ts
import { http } from '@/http' // 手写 API 的标准用法
```

## 出口清单（src/http/index.ts）

| 导出 | 说明 | 使用方 |
| --- | --- | --- |
| `http`（别名 `nativeHttp`） | **唯一请求栈**：原生 `uni.request` 适配器，H5/小程序全端兼容；URL 由全局 interceptor **唯一拼接**（`getEnvBaseUrl()` 三环境域名 + `/api/v1` 前缀，幂等防双前缀）；内置 401 无感刷新 | 手写 API（`api/auth.ts`、`api/user.ts`、注册页、test-http 页等） |
| `API_DOMAINS` | 域名切换：`DEFAULT`（三环境）/ `SECONDARY`（`VITE_API_BASE_URL_SECONDARY` 备用域名，未配置回退 DEFAULT），经 `meta.domain` 显式指定后直连 | 需要切备用域名的请求 |
| `openapiRequest` | **生成层适配器**（`vue-query.ts`，不是第二套请求）：把 openapi-ts-request 生成的 axios 风格 `request(url, { params, headers })` 翻译成主栈单对象签名后**转调 `http`** | `src/service/*`（代码生成产物） |
| `requestInterceptor` | uni 全局 request/uploadFile 拦截器：相对路径补全 + 注入 `Authorization: Bearer` | `main.ts` 装配 |
| `ResultEnum` / `ContentTypeEnum` | 业务码 / Content-Type 枚举 | 各处 |
| 类型 `CustomRequestOptions` 等 | 请求选项（含 `meta.domain`）与响应类型 | 各处 |

主栈兼容两种调用风格：`http.get/post/...`（axios 风）与 `http.Get/Post/...`（大写别名，历史兼容）。

### 备用域名（VITE_API_BASE_URL_SECONDARY）

```ts
import { API_DOMAINS, http } from '@/http'

// 该请求直连备用域名（跳过 H5 代理与三环境解析；/api/v1 前缀仍由拦截器幂等拼接）
http.Post('/some/api', body, undefined, undefined, { meta: { domain: API_DOMAINS.SECONDARY } })
```

`env/.env.development` 中 `VITE_API_BASE_URL_SECONDARY` 留空即回退 `VITE_API_BASE_URL`。

## 401 无感刷新（`http/http.ts`）

判据（任一命中）：HTTP `statusCode === 401` · 业务码 `code === 401` ·
业务码 `code === 10401`（后端 `CustomException` 鉴权失败 = HTTP 401 + body `code:10401`）。

命中后按序处理：

1. 无 refresh token，或本请求已重放过一次（`__retried`）→ `userStore.logout()` 回登录页；
2. 已有刷新在途（`refreshing`）→ 并发请求入 `taskQueue` 挂起等待，不重复触发刷新；
3. 否则 `await userStore.refreshToken()`（`POST /system/auth/token/refresh`，body
   `{ refresh_token }`）→ 双写持久化新 token → 出队**重放原请求**
   （`__retried: true` 防循环），失败则清队并登出。

`userStore.logout()` 仅在**持有 refresh token 时**才调后端 `/logout` —— 未登录态的
失败路径只做本地清理，避免 401/429 请求风暴。

## 生成层约定（openapi-ts-request）

`src/service/*` 为生成代码、不手改；其导入模板由 `openapi-ts-request.config.ts` 的
`requestLibPath` 指定（当前即 `@/http` 的 `openapiRequest` + `CustomRequestOptions_`），
**重新执行 `pnpm openapi` 不会回退到旧导入路径**。

## 如何选择

- **手写接口** → `http`（唯一请求栈）
- **`src/service` 生成代码** → 生成器固定用 `openapiRequest`（底层仍是主栈）
- **切备用域名** → `{ meta: { domain: API_DOMAINS.SECONDARY } }`

## 验证

- 连通性自证页：路由 `pages/test-http`（主栈 `http.Get` 打白名单 `captcha/get`，
  页面回显「成功/错误」原文，无需登录）
- 401 刷新回归：登录态下把 localStorage 的 `appAccessToken` 改坏后发起受保护请求，
  network 面板应出现 `401 → token/refresh 200 → 重放 200` 序列
- 刷新时序排查：dev 控制台过滤关键字 `[http]`（四点 debug：
  命中判据 → 入队/开始刷新 → 重放发出；失败分支有 `console.error`）
