/**
 * http 模块唯一出口：外部（api/pages/store/service 等）一律从 '@/http' 导入，
 * 禁止直连 @/http/* 子路径（eslint no-restricted-imports 执法）。
 */

// 主栈：原生 uni.request 适配器（H5/小程序全端兼容，默认请求入口）
export { http, http as nativeHttp } from './http'
// 域名切换：DEFAULT 走三环境（getEnvBaseUrl），SECONDARY 备用域名（VITE_API_BASE_URL_SECONDARY）
export { API_DOMAINS, requestInterceptor } from './interceptor'
// 常用枚举
export { ContentTypeEnum, ResultEnum } from './tools/enum'
// 类型
export type { CustomRequestOptions, CustomRequestOptions_, HttpRequestResult, IResponse } from './types'
// openapi-ts-request 生成层适配器（src/service 使用）
export { default as openapiRequest } from './vue-query'
