/**
 * 在 uniapp 的 RequestOptions 和 UploadFileOption 基础上，添加自定义参数
 */
export type CustomRequestOptions = Omit<UniApp.RequestOptions, 'method'> & {
  /** HTTP 方法（uni 官方类型缺 PATCH，小程序实际支持，此处补齐） */
  method?: UniApp.RequestOptions['method'] | 'PATCH'
  query?: Record<string, any>
  /** 出错时是否隐藏错误提示 */
  hideErrorToast?: boolean
  /** 请求元信息 */
  meta?: {
    /**
     * 自定义请求域名（不含 /api/v1 前缀），指定后跳过 H5 代理与三环境域名解析。
     * 配合 `API_DOMAINS.SECONDARY`（VITE_API_BASE_URL_SECONDARY）切换备用域名。
     */
    domain?: string
  }
  /** 401 刷新后的重放标记（仅请求内部流转，不对外暴露） */
  __retried?: boolean
} & UniApp.UploadFileOption // 添加uni.uploadFile参数类型

/** 主要提供给 openapi-ts-request 生成的代码使用 */
export type CustomRequestOptions_ = Omit<CustomRequestOptions, 'url'>

export interface HttpRequestResult<T> {
  promise: Promise<T>
  requestTask: UniApp.RequestTask
}

// 通用响应格式（兼容 msg + message 字段）
export type IResponse<T = any> =
  | {
      code: number
      data: T
      msg: string
      status_code: number
      success: boolean
      [key: string]: any // 允许额外属性
    }
  | {
      code: number
      data: T
      msg: string
      status_code: number
      success: boolean
      [key: string]: any // 允许额外属性
    }

// 分页请求参数
export interface PageParams {
  page: number
  pageSize: number
  [key: string]: any
}

// 分页响应数据
export interface PageResult<T> {
  list: T[]
  total: number
  page: number
  pageSize: number
}
