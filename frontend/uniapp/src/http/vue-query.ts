import { http } from './http'
import type { CustomRequestOptions } from './types'

/*
 * openapi-ts-request 工具的 request 跨客户端适配方法。
 * 泛型 T 即业务体类型（生成器语义）：http 已解包信封返回 data，故直接返回 T。
 */
export default function request<T>(
  url: string,
  options: Omit<CustomRequestOptions, 'url'> & {
    params?: Record<string, unknown>
    headers?: Record<string, unknown>
  }
) {
  const requestOptions = {
    url,
    ...options,
  }

  if (options.params) {
    requestOptions.query = requestOptions.params
    delete requestOptions.params
  }

  if (options.headers) {
    requestOptions.header = options.headers
    delete requestOptions.headers
  }

  return http<T>(requestOptions)
}
