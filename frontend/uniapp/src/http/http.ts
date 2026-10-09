import { isDoubleTokenMode } from '@/utils'
import { ResultEnum } from './tools/enum'
import type { CustomRequestOptions, IResponse } from './types'

// 401 无感刷新状态（防重入 + 并发请求队列）
let refreshing = false
let taskQueue: (() => void)[] = []

export function http<T>(options: CustomRequestOptions) {
  // 1. 返回 Promise 对象
  return new Promise<T>((resolve, reject) => {
    // URL 拼接（三环境域名 + /api/v1 前缀）统一由全局 interceptor 完成，此处不再拼接
    uni.request({
      ...options,
      // uni 官方类型缺 PATCH（小程序运行时实际支持），调用点收窄以过类型检查
      method: options.method as UniApp.RequestOptions['method'],
      dataType: 'json',
      // #ifndef MP-WEIXIN
      responseType: 'json',
      // #endif
      // 响应成功
      success: async (res) => {
        const responseData = res.data as IResponse<T>
        const { code } = responseData

        // 检查是否是401错误（HTTP 401、业务码 401，或后端鉴权业务码 10401）
        const isTokenExpired =
          res.statusCode === 401 || code === ResultEnum.Unauthorized || code === ResultEnum.TokenInvalid

        if (isTokenExpired) {
          // 刷新/登出仅 401 分支需要 userStore：动态加载（不可静态 import：
          // http → userStore → api/auth → @/http 成环，rollup 跨 chunk 循环）；
          // 模块已在主包，命中 401 时加载无网络开销，成功路径零成本
          const { useUserStore } = await import('@/store/userStore')
          const userStore = useUserStore()
          const canRefresh = isDoubleTokenMode && !!userStore.getRefreshToken()
          console.debug('[http] 401 命中', { canRefresh, retried: !!options.__retried })

          // 无刷新能力或已重放过仍 401 → 登出回登录页（logout 内部会 reLaunch）
          if (!canRefresh || options.__retried) {
            await userStore.logout()
            return reject(res)
          }

          // 已有刷新在途：入队等刷新完成后重放（不 settle 当前 promise）
          if (refreshing) {
            console.debug('[http] 刷新在途，请求入队等待')
            taskQueue.push(() => resolve(http<T>({ ...options, __retried: true })))
            return
          }

          console.debug('[http] 开始刷新 access token')
          refreshing = true
          taskQueue.push(() => resolve(http<T>({ ...options, __retried: true })))
          try {
            await userStore.refreshToken()
          } catch (refreshErr) {
            console.error('刷新 token 失败:', refreshErr)
            taskQueue = []
            await userStore.logout()
            return reject(res)
          } finally {
            refreshing = false
          }
          const tasks = taskQueue
          taskQueue = []
          console.debug('[http] 刷新完成，重放', tasks.length, '个排队请求')
          tasks.forEach((task) => task())
          return
        }

        // 处理其他成功状态（HTTP状态码200-299）
        if (res.statusCode >= 200 && res.statusCode < 300) {
          // 处理业务逻辑错误
          if (code !== ResultEnum.Success0) {
            uni.showToast({
              icon: 'error',
              title: responseData.msg || responseData.message || '请求错误',
            })
            return reject(responseData)
          }
          return resolve(responseData.data)
        }

        // 处理其他错误
        if (!options.hideErrorToast) {
          uni.showToast({
            icon: 'error',
            title: (res.data as any).msg || '请求错误',
          })
        }
        reject(res)
      },
      // 响应失败
      fail(err) {
        uni.showToast({
          icon: 'none',
          title: '网络错误，换个网络试试',
        })
        reject(err)
      },
    })
  })
}

/**
 * GET 请求
 * @param url 后台地址
 * @param query 请求query参数
 * @param header 请求头，默认为json格式
 * @returns 返回包含响应数据的 Promise
 */
export function httpGet<T>(
  url: string,
  query?: Record<string, any>,
  header?: Record<string, any>,
  options?: Partial<CustomRequestOptions>
) {
  return http<T>({
    url,
    query,
    method: 'GET',
    header,
    ...options,
  })
}

/**
 * POST 请求
 * @param url 后台地址
 * @param data 请求body参数
 * @param query 请求query参数，post请求也支持query，很多微信接口都需要
 * @param header 请求头，默认为json格式
 * @returns 返回包含响应数据的 Promise
 */
export function httpPost<T>(
  url: string,
  data?: Record<string, any>,
  query?: Record<string, any>,
  header?: Record<string, any>,
  options?: Partial<CustomRequestOptions>
) {
  return http<T>({
    url,
    query,
    data,
    method: 'POST',
    header,
    ...options,
  })
}
/**
 * PUT 请求
 */
export function httpPut<T>(
  url: string,
  data?: Record<string, any>,
  query?: Record<string, any>,
  header?: Record<string, any>,
  options?: Partial<CustomRequestOptions>
) {
  return http<T>({
    url,
    data,
    query,
    method: 'PUT',
    header,
    ...options,
  })
}

/**
 * DELETE 请求（无请求体，仅 query）
 */
export function httpDelete<T>(
  url: string,
  query?: Record<string, any>,
  header?: Record<string, any>,
  options?: Partial<CustomRequestOptions>
) {
  return http<T>({
    url,
    query,
    method: 'DELETE',
    header,
    ...options,
  })
}

// 支持与 axios 类似的API调用
http.get = httpGet
http.post = httpPost
http.put = httpPut
http.delete = httpDelete

// 大写别名（Get/Post/...）：历史调用风格兼容，语义与小写版一致
http.Get = httpGet
http.Post = httpPost
http.Put = httpPut
http.Delete = httpDelete
