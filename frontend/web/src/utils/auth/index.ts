/**
 * Auth 认证令牌管理。
 *
 * 注意：令牌存储直接操作 localStorage / sessionStorage，而非经过 @utils/storage 的
 * Storage 工具类。这是因为：
 * 1. 令牌使用固定键名（access_token / refresh_token），不需要版本化键名前缀
 * 2. rememberMe 机制需要在两端（localStorage / sessionStorage）间切换
 * 3. 令牌值已是字符串，无需 JSON 序列化/反序列化
 *
 * @module Auth
 */

const AUTH_KEYS = {
  ACCESS_TOKEN: 'access_token',
  REFRESH_TOKEN: 'refresh_token',
  REMEMBER_ME: 'remember_me',
} as const

export class Auth {
  static isLoggedIn(): boolean {
    return !!Auth.getAccessToken()
  }

  static getAccessToken(): string {
    const isRememberMe = Auth.getRememberMe()
    return isRememberMe
      ? localStorage.getItem(AUTH_KEYS.ACCESS_TOKEN) || ''
      : sessionStorage.getItem(AUTH_KEYS.ACCESS_TOKEN) || ''
  }

  static getRefreshToken(): string {
    const isRememberMe = Auth.getRememberMe()
    return isRememberMe
      ? localStorage.getItem(AUTH_KEYS.REFRESH_TOKEN) || ''
      : sessionStorage.getItem(AUTH_KEYS.REFRESH_TOKEN) || ''
  }

  static setTokens(accessToken: string, refreshToken: string, rememberMe: boolean): void {
    localStorage.setItem(AUTH_KEYS.REMEMBER_ME, String(rememberMe))

    if (rememberMe) {
      localStorage.setItem(AUTH_KEYS.ACCESS_TOKEN, accessToken)
      localStorage.setItem(AUTH_KEYS.REFRESH_TOKEN, refreshToken)
    } else {
      sessionStorage.setItem(AUTH_KEYS.ACCESS_TOKEN, accessToken)
      sessionStorage.setItem(AUTH_KEYS.REFRESH_TOKEN, refreshToken)
      localStorage.removeItem(AUTH_KEYS.ACCESS_TOKEN)
      localStorage.removeItem(AUTH_KEYS.REFRESH_TOKEN)
    }
  }

  static clearAuth(): void {
    localStorage.removeItem(AUTH_KEYS.ACCESS_TOKEN)
    localStorage.removeItem(AUTH_KEYS.REFRESH_TOKEN)
    sessionStorage.removeItem(AUTH_KEYS.ACCESS_TOKEN)
    sessionStorage.removeItem(AUTH_KEYS.REFRESH_TOKEN)
  }

  static getRememberMe(): boolean {
    return localStorage.getItem(AUTH_KEYS.REMEMBER_ME) === 'true'
  }
}

export { AUTH_KEYS }

import { router } from '@/router'
import { useMenuStore } from '@stores/modules/menu.store'
import { useUserStore } from '@stores/modules/user.store'
import { ElMessage, ElNotification } from 'element-plus'

/** 登录页跳转进行中，合并并发调用，避免重复通知与重复路由 */
let redirectToLoginInFlight: Promise<void> | null = null
/**
 * 失效提示收敛窗口：一次失效流程常伴随多个连锁 redirectToLogin 调用
 * （拦截器 refresh-401 分支 + 发起方 catch），完成后窗口内的重复调用
 * 静默吞并——只提示一次、只跳转一次。3500ms 覆盖 ElNotification 的 3s 展示期。
 * 与 inFlight（并发合并）解耦：inFlight 在 finally 即时释放，两者各管一层。
 */
const REDIRECT_COOLDOWN_MS = 3500
let lastRedirectDoneAt = 0

/**
 * 认证失效或需重新登录时跳转登录页：清空本地会话并带上 redirect。
 * 与 HTTP 拦截器、改密后重登等场景共用；并发只执行一次。
 */
export async function redirectToLogin(message: string = '请重新登录'): Promise<void> {
  if (redirectToLoginInFlight) return redirectToLoginInFlight
  // 冷却窗口内（刚完成过一次失效跳转）：连锁重复调用静默吞并
  if (Date.now() - lastRedirectDoneAt < REDIRECT_COOLDOWN_MS) return

  redirectToLoginInFlight = (async () => {
    try {
      ElNotification({
        title: '提示',
        message,
        type: 'warning',
        duration: 3000,
      })

      await useUserStore().resetAllState()

      // 清除菜单缓存：守卫通过 menuList.length 判断是否需要重新注册动态路由。
      // 若不清除，重新登录后守卫误认为路由已就绪而跳过注册，导致首次登录不跳转。
      useMenuStore().resetAllState()

      const currentRoute = router.currentRoute.value
      // 已在登录页时不再跳转：否则会把登录页 URL 再塞进 redirect，形成
      // /login?redirect=/login?redirect=xxx 的嵌套，登录成功后被送回登录页
      // （表现为「首次登录不跳转，再点一次才跳」）。判定与 userStore.logout 一致。
      if (currentRoute.path === '/login') return

      await router.push(`/login?redirect=${encodeURIComponent(currentRoute.fullPath)}`)
    } catch (error: any) {
      ElMessage.error(error?.message ?? String(error))
    } finally {
      redirectToLoginInFlight = null
      lastRedirectDoneAt = Date.now()
    }
  })()

  return redirectToLoginInFlight
}
