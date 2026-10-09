import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import { icons as riIcons } from '@iconify-json/ri'
import { addCollection } from '@iconify/vue'
import type { App } from 'vue'

// 注册所有图标
export function initElIcons(app: App<Element>) {
  for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
    app.component(key, component)
  }
}

/**
 * 本地注册 Iconify 图标集（仅 ri，图标风格统一为 Remix Icon）。
 *
 * `<FaSvgIcon>`（`@iconify/vue` 的 `<Icon>`）默认从 `api.iconify.design`
 * 在线拉取图标数据，网络不可达时报 `ERR_CONNECTION_CLOSED` 且图标全空。
 * 启动时本地注册后按需命中即渲染，不再发起远程请求（离线可用）。
 */
export function initIconifyIcons(): void {
  addCollection(riIcons)
}
