import { APP_ACCESS_TOKEN_KEY } from '@/constants'
import { getEnvBaseUrl } from '@/utils'
import { Storage } from '@/utils/storage'
import { stringifyQuery } from './tools/queryString'
import type { CustomRequestOptions } from './types'

// 后端统一前缀（代理 key 即该前缀；拼接时防重复叠加）
const apiPrefix = import.meta.env.VITE_APP_BASE_API || ''

/**
 * 域名切换（均不含 /api/v1 前缀，前缀由拦截器统一幂等拼接）：
 * - DEFAULT：三环境域名（getEnvBaseUrl，微信端按 develop/trial/release 细分），默认路径
 * - SECONDARY：备用域名（VITE_API_BASE_URL_SECONDARY），不配置则回退 DEFAULT；
 *   经 `meta.domain` 显式指定后直连，跳过 H5 代理与三环境解析
 */
export const API_DOMAINS = {
  DEFAULT: import.meta.env.VITE_API_BASE_URL || '',
  SECONDARY: import.meta.env.VITE_API_BASE_URL_SECONDARY || import.meta.env.VITE_API_BASE_URL || '',
}

// 拦截器配置
const httpInterceptor = {
  // 拦截前触发
  invoke(options: CustomRequestOptions) {
    // 接口请求支持通过 query 参数配置 queryString
    if (options.query) {
      const queryStr = stringifyQuery(options.query)
      if (options.url.includes('?')) {
        options.url += `&${queryStr}`
      } else {
        options.url += `?${queryStr}`
      }
    }
    // 非 http 开头需拼接地址（URL 唯一拼接点：三环境域名 + /api/v1 前缀；
    // 前缀已带则不重复叠加——幂等防御直发相对路径已含 /api/v1 的情况）
    if (!options.url.startsWith('http')) {
      const path = options.url.startsWith(apiPrefix) ? options.url : apiPrefix + options.url
      // 显式域名（API_DOMAINS.SECONDARY 等）优先：直连，不走代理/三环境
      if (options.meta?.domain) {
        options.url = options.meta.domain + path
      } else {
        // #ifdef H5
        // 变量在 production mode 可能未定义，字符串比较避免 JSON.parse(undefined) 崩溃
        if (import.meta.env.VITE_APP_PROXY_ENABLE === 'true') {
          // H5 走 dev 代理：代理 key 即 /api/v1 前缀，必须带前缀才命中
          options.url = (import.meta.env.VITE_APP_PROXY_PREFIX || '') + path
        } else {
          options.url = getEnvBaseUrl() + path
        }
        // #endif
        // 非H5正常拼接
        // #ifndef H5
        options.url = getEnvBaseUrl() + path
        // #endif
      }
    }
    // 1. 请求超时
    options.timeout = 60000 // 60s
    // 2. （可选）添加小程序端请求头标识
    options.header = {
      ...options.header,
    }
    // 3. 添加 token 请求头标识
    // 直读 Storage，不可 import userStore：userStore → api → @/http → 本文件成环，
    // rollup 会报跨 chunk 循环依赖（getAccessToken 本就是 Storage.get 的包装）
    const token = Storage.get<string>(APP_ACCESS_TOKEN_KEY)
    if (token) {
      options.header.Authorization = `Bearer ${token}`
    }
    return options
  },
}

export const requestInterceptor = {
  install() {
    // 拦截 request 请求
    uni.addInterceptor('request', httpInterceptor)
    // 拦截 uploadFile 文件上传
    uni.addInterceptor('uploadFile', httpInterceptor)
  },
}
