/// <reference types="vite/client" />
/// <reference types="vite-svg-loader" />

declare module '*.vue' {
  import type { DefineComponent } from 'vue'

  const component: DefineComponent<{}, {}, any>
  export default component
}

interface ImportMetaEnv {
  /** 网站标题，应用名称 */
  readonly VITE_APP_TITLE: string
  /** 服务端口号 */
  readonly VITE_SERVER_PORT: string
  /** 后台接口地址（与 VITE_APP_BASE_API 拼接为完整请求地址） */
  readonly VITE_API_BASE_URL: string
  /** 备用接口域名（不配置则回退 VITE_API_BASE_URL；经 @/http 的 API_DOMAINS.SECONDARY + meta.domain 使用） */
  readonly VITE_API_BASE_URL_SECONDARY?: string
  /** 微信小程序开发版后台接口地址，不配置则使用 VITE_API_BASE_URL */
  readonly VITE_API_BASE_URL__WEIXIN_DEVELOP?: string
  /** 微信小程序体验版后台接口地址，不配置则使用 VITE_API_BASE_URL */
  readonly VITE_API_BASE_URL__WEIXIN_TRIAL?: string
  /** 微信小程序正式版后台接口地址，不配置则使用 VITE_API_BASE_URL */
  readonly VITE_API_BASE_URL__WEIXIN_RELEASE?: string
  /** H5是否需要代理 */
  readonly VITE_APP_PROXY_ENABLE: 'true' | 'false'
  /** API 路径前缀 */
  readonly VITE_APP_BASE_API: string
  /** 认证模式，'single' | 'double' ==> 单token | 双token */
  readonly VITE_AUTH_MODE: 'single' | 'double'
  /** 是否清除console */
  readonly VITE_DELETE_CONSOLE: string
  // 更多环境变量...
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

declare const __VITE_APP_PROXY__: 'true' | 'false'
