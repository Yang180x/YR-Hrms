import { requestInterceptor } from '@/http'
import { createSSRApp } from 'vue'
import App from './App.vue'
import { routeInterceptor } from './router/interceptor.js'

import '@/style/index.scss'
import 'virtual:uno.css'
import store from './store/index.js'

export function createApp() {
  const app = createSSRApp(App)
  app.use(store)
  app.use(routeInterceptor)
  app.use(requestInterceptor)

  return {
    app,
  }
}
