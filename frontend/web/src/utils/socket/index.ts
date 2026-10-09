/**
 * WebSocket 服务管理
 *
 * @description
 * 统一管理应用中的所有 WebSocket 连接
 * - 字典同步 WebSocket
 * - 在线用户计数 WebSocket
 * - 其他业务 WebSocket
 *
 * @author fastapiadmin
 */

import { Auth } from '@utils/auth'

/**
 * WebSocket 服务实例约定接口
 */
type WebSocketService = {
  disconnect?: () => void
  closeWebSocket?: () => void
  cleanup?: () => void
  [key: string]: any
}

/**
 * 全局 WebSocket 实例管理
 */
const websocketInstances = new Map<string, WebSocketService>()

/**
 * 防止重复初始化的状态标记
 */
let isInitialized = false

/**
 * 注册 WebSocket 实例
 */
export function registerWebSocketInstance(key: string, instance: WebSocketService) {
  websocketInstances.set(key, instance)
}

/**
 * 获取 WebSocket 实例
 */
export function getWebSocketInstance(key: string) {
  return websocketInstances.get(key)
}

/**
 * 初始化 WebSocket 服务
 */
export function setupWebSocket() {
  if (isInitialized) {
    console.warn('[WebSocket] 已初始化，跳过重复初始化')
    return
  }

  if (!Auth.getAccessToken()) {
    console.warn('[WebSocket] 未登录，跳过 WebSocket 初始化')
    return
  }

  try {
    isInitialized = true
    console.info('[WebSocket] 初始化成功')
  } catch (error) {
    console.error('[WebSocket] 初始化失败:', error)
  }
}

/**
 * 清理所有 WebSocket 连接
 */
export function cleanupWebSocket() {
  console.info('[WebSocket] 开始清理连接...')

  websocketInstances.forEach((instance, key) => {
    try {
      if (instance.disconnect) {
        instance.disconnect()
      } else if (instance.closeWebSocket) {
        instance.closeWebSocket()
      } else if (instance.cleanup) {
        instance.cleanup()
      }
      console.info(`[WebSocket] ${key} 已断开`)
    } catch (error) {
      console.error(`[WebSocket] ${key} 清理失败:`, error)
    }
  })

  websocketInstances.clear()
  isInitialized = false
  console.info('[WebSocket] 清理完成')
}

/**
 * 重新初始化 WebSocket
 */
export function reinitializeWebSocket() {
  cleanupWebSocket()
  setupWebSocket()
}

if (typeof window !== 'undefined') {
  window.addEventListener('beforeunload', () => {
    cleanupWebSocket()
  })
}

/**
 * WebSocket 客户端类
 *
 * 提供 WebSocket 连接管理功能，支持自动重连、心跳检测和消息队列
 *
 * @module utils/socket
 */

/**
 * 与 `WebSocket.send` 参数同源的消息类型
 *
 * 不直接写 `string | ArrayBufferLike | Blob | ArrayBufferView`：
 * `ArrayBufferView` 默认泛型参数为 `ArrayBufferLike`（含 `SharedArrayBuffer`），
 * 而 DOM 的 `BufferSource` 只接受 `ArrayBuffer` 视图，直接赋值会触发 ts(2345)
 */
type SocketSendData = Parameters<WebSocket['send']>[0]

interface WebSocketOptions {
  url?: string
  /** 动态取连接地址（每次连接/重连时调用，用于刷新已过期的 token）；优先于 url */
  getUrl?: () => string
  messageHandler: (event: MessageEvent) => void
  /** 连接状态回调：connecting / open / closed */
  onStatusChange?: (status: 'connecting' | 'open' | 'closed') => void
  reconnectInterval?: number // 重连基础延迟(ms)，实际 = min(base*2^n, 30s) + 随机抖动
  heartbeatInterval?: number // 心跳检测间隔(ms)
  pingInterval?: number // 发送ping间隔(ms)
  pongTimeout?: number // 发 ping 后等响应的超时(ms)，超时主动断连触发重连（防 TCP 假死）
  reconnectTimeout?: number // 重连超时时间(ms)
  maxReconnectAttempts?: number // 最大重连次数
  connectionTimeout?: number // 连接建立超时时间(ms)
}

export default class WebSocketClient {
  private static instance: WebSocketClient | null = null
  private ws: WebSocket | null = null
  private url: string
  private messageHandler: (event: MessageEvent) => void
  private reconnectInterval: number
  private heartbeatInterval: number
  private pingInterval: number
  private pongTimeout: number // 发 ping 后等响应超时(ms)，超时视为假死
  private reconnectTimeout: number
  private maxReconnectAttempts: number
  private connectionTimeout: number
  private reconnectAttempts: number = 0 // 当前重连次数
  private pongTimer: NodeJS.Timeout | null = null // pong 超时（防假死）
  private getUrl?: () => string
  private onStatusChange?: (status: 'connecting' | 'open' | 'closed') => void

  // 消息队列 - 缓存连接建立前的消息
  private messageQueue: SocketSendData[] = []

  // 定时器
  private detectionTimer: NodeJS.Timeout | null = null
  private timeoutTimer: NodeJS.Timeout | null = null
  private reconnectTimer: NodeJS.Timeout | null = null
  private pingTimer: NodeJS.Timeout | null = null
  private connectionTimer: NodeJS.Timeout | null = null // 连接超时定时器

  // 状态标识
  private isConnected: boolean = false
  private isConnecting: boolean = false // 是否正在连接中
  private stopReconnect: boolean = false
  private isReconnecting: boolean = false

  private constructor(options: WebSocketOptions) {
    this.url = options.url ?? ''
    this.getUrl = options.getUrl
    this.onStatusChange = options.onStatusChange
    this.messageHandler = options.messageHandler
    this.reconnectInterval = options.reconnectInterval ?? 1000 // 重连基础延迟1s（文章 v2：1s 起指数退避）
    this.heartbeatInterval = options.heartbeatInterval ?? 5 * 1000 // 默认5秒
    this.pingInterval = options.pingInterval ?? 10 * 1000 // 默认10秒
    this.pongTimeout = options.pongTimeout ?? 10 * 1000 // 发 ping 后10s 无响应视为假死
    this.reconnectTimeout = options.reconnectTimeout ?? 30 * 1000 // 默认30秒
    this.maxReconnectAttempts = options.maxReconnectAttempts ?? 10 // 默认最多重连10次
    this.connectionTimeout = options.connectionTimeout ?? 10 * 1000 // 连接超时10秒

    // 文章 v4：网络恢复立即重连；页面回前台主动探测（后台标签定时器会被节流）
    if (typeof window !== 'undefined') {
      window.addEventListener('online', this.handleOnline)
      document.addEventListener('visibilitychange', this.handleVisibilityChange)
    }
  }

  // 单例模式获取实例
  static getInstance(options: WebSocketOptions): WebSocketClient {
    if (!WebSocketClient.instance) {
      WebSocketClient.instance = new WebSocketClient(options)
    } else {
      // 更新消息处理器
      WebSocketClient.instance.messageHandler = options.messageHandler
      // 如果提供了新的URL，则更新并重新连接
      if (options.url && WebSocketClient.instance.url !== options.url) {
        WebSocketClient.instance.url = options.url
        WebSocketClient.instance.reconnectAttempts = 0
        WebSocketClient.instance.init()
      }
    }
    return WebSocketClient.instance
  }

  // 初始化连接
  init(): void {
    this.connect(true)
  }

  private connect(resetReconnectAttempts: boolean = false): void {
    // 如果正在连接中，不重复连接
    if (this.isConnecting) {
      console.info('正在建立WebSocket连接中...')
      return
    }

    // 如果已连接，不重复连接
    if (this.ws?.readyState === WebSocket.OPEN) {
      console.warn('WebSocket连接已存在')
      this.flushMessageQueue() // 确保队列中的消息被发送
      return
    }

    try {
      this.isConnecting = true
      this.stopReconnect = false
      if (resetReconnectAttempts) {
        this.reconnectAttempts = 0
        this.isReconnecting = false
        this.clearTimer('reconnectTimer')
      }
      const target = this.getUrl ? this.getUrl() : this.url
      if (!target) {
        console.error('WebSocket地址为空：需提供 url 或 getUrl')
        this.isConnecting = false
        return
      }
      this.onStatusChange?.('connecting')
      this.ws = new WebSocket(target)

      // 设置连接超时检测
      this.clearTimer('connectionTimer')
      this.connectionTimer = setTimeout(() => {
        console.error(`WebSocket连接超时 (${this.connectionTimeout}ms)：${this.url}`)
        this.handleConnectionTimeout()
      }, this.connectionTimeout)

      this.ws.onopen = (event) => this.handleOpen(event)
      this.ws.onmessage = (event) => this.handleMessage(event)
      this.ws.onclose = (event) => this.handleClose(event)
      this.ws.onerror = (event) => this.handleError(event)
    } catch (error) {
      console.error('WebSocket初始化失败:', error)
      this.isConnecting = false
      this.reconnect()
    }
  }

  // 处理连接超时
  private handleConnectionTimeout(): void {
    if (this.ws?.readyState !== WebSocket.OPEN) {
      console.error('WebSocket连接超时，强制关闭连接')
      this.ws?.close(1000, 'Connection timeout')
      this.isConnecting = false
      this.reconnect()
    }
  }

  // 关闭连接
  close(force?: boolean): void {
    this.clearAllTimers()
    this.stopReconnect = true
    this.isReconnecting = false
    this.isConnecting = false

    if (this.ws) {
      // 1000 表示正常关闭
      this.ws.close(force ? 1001 : 1000, force ? 'Force closed' : 'Normal close')
      this.ws = null
    }

    this.isConnected = false
  }

  // 发送消息 - 增加消息队列
  send(data: SocketSendData, immediate: boolean = false): void {
    // 如果要求立即发送且未连接，则直接报错
    if (immediate && (!this.ws || this.ws.readyState !== WebSocket.OPEN)) {
      console.error('WebSocket未连接，无法立即发送消息')
      return
    }

    // 如果未连接且不要求立即发送，则加入消息队列
    if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
      console.info('WebSocket未连接，消息已加入队列等待发送')
      this.messageQueue.push(data)
      // 如果未在重连中，则尝试重连
      if (!this.isConnecting && !this.stopReconnect) {
        this.init()
      }
      return
    }

    try {
      this.ws.send(data)
    } catch (error) {
      console.error('WebSocket发送消息失败:', error)
      // 发送失败时将消息加入队列，等待重连后重试
      this.messageQueue.push(data)
      this.reconnect()
    }
  }

  // 发送队列中的消息
  private flushMessageQueue(): void {
    if (this.messageQueue.length > 0 && this.ws?.readyState === WebSocket.OPEN) {
      console.info(`发送队列中的${this.messageQueue.length}条消息`)
      while (this.messageQueue.length > 0) {
        const data = this.messageQueue.shift()
        if (data) {
          try {
            this.ws?.send(data)
          } catch (error) {
            console.error('发送队列消息失败:', error)
            // 如果发送失败，将消息放回队列头部
            if (data) this.messageQueue.unshift(data)
            break
          }
        }
      }
    }
  }

  // 处理连接打开
  private handleOpen(event: Event): void {
    console.info('WebSocket连接成功', event)
    this.onStatusChange?.('open')
    this.clearTimer('connectionTimer') // 清除连接超时定时器
    this.isConnected = true
    this.isConnecting = false
    this.isReconnecting = false
    this.stopReconnect = false
    this.reconnectAttempts = 0 // 重置重连次数
    this.startHeartbeat()
    this.startPing()
    this.flushMessageQueue() // 发送队列中的消息
  }

  // 处理收到的消息
  private handleMessage(event: MessageEvent): void {
    console.debug('收到WebSocket消息:', event)
    // 收到任意消息即为活性证据，取消 pong 超时
    this.clearTimer('pongTimer')
    this.resetHeartbeat()
    // 心跳响应不透传给业务层
    if (this.isPongMessage(event.data)) {
      console.debug('收到pong，连接活跃')
      return
    }
    this.messageHandler(event)
  }

  /** 是否为心跳响应（兼容文本与 JSON 两种 pong 形态） */
  private isPongMessage(data: unknown): boolean {
    if (data === 'pong' || data === '{"type":"pong"}') return true
    if (typeof data !== 'string') return false
    try {
      const msg = JSON.parse(data)
      return !!msg && msg.type === 'pong'
    } catch {
      return false
    }
  }

  // 处理连接关闭
  private handleClose(event: CloseEvent): void {
    console.info(`WebSocket断开: 代码=${event.code}, 原因=${event.reason}, 干净关闭=${event.wasClean}`)
    this.onStatusChange?.('closed')

    // 1000 是正常关闭代码
    const isNormalClose = event.code === 1000

    this.isConnected = false
    this.isConnecting = false
    this.clearConnectionTimers()
    this.ws = null

    if (!this.stopReconnect && !isNormalClose) {
      this.reconnect()
    }
  }

  // 处理错误 - 增加详细错误信息
  private handleError(event: Event): void {
    console.error('WebSocket连接错误:')
    console.error('错误事件:', event)
    console.error('当前连接状态:', this.ws?.readyState ? this.getReadyStateText(this.ws.readyState) : '未初始化')

    this.isConnected = false
    this.isConnecting = false

    // 只有在未停止重连的情况下才尝试重连
    if (!this.stopReconnect) {
      this.reconnect()
    }
  }

  private closeCurrentSocketForReconnect(): void {
    this.clearConnectionTimers()
    this.isConnected = false
    this.isConnecting = false

    if (this.ws) {
      this.ws.onopen = null
      this.ws.onmessage = null
      this.ws.onclose = null
      this.ws.onerror = null

      if (this.ws.readyState === WebSocket.OPEN || this.ws.readyState === WebSocket.CONNECTING) {
        this.ws.close(1001, 'Reconnect')
      }

      this.ws = null
    }
  }

  // 转换连接状态为文本描述
  private getReadyStateText(state: number): string {
    switch (state) {
      case WebSocket.CONNECTING:
        return 'CONNECTING (0) - 正在连接'
      case WebSocket.OPEN:
        return 'OPEN (1) - 已连接'
      case WebSocket.CLOSING:
        return 'CLOSING (2) - 正在关闭'
      case WebSocket.CLOSED:
        return 'CLOSED (3) - 已关闭'
      default:
        return `未知状态 (${state})`
    }
  }

  // 开始心跳检测
  private startHeartbeat(): void {
    this.clearTimer('detectionTimer')
    this.clearTimer('timeoutTimer')

    this.detectionTimer = setTimeout(() => {
      this.isConnected = this.ws?.readyState === WebSocket.OPEN

      if (!this.isConnected) {
        console.warn('WebSocket心跳检测失败，尝试重连')
        this.reconnect()

        this.timeoutTimer = setTimeout(() => {
          console.warn('WebSocket重连超时')
          this.close()
        }, this.reconnectTimeout)
      }
    }, this.heartbeatInterval)
  }

  // 重置心跳检测
  private resetHeartbeat(): void {
    this.clearTimer('detectionTimer')
    this.clearTimer('timeoutTimer')
    this.startHeartbeat()
  }

  // 开始发送ping消息
  private startPing(): void {
    this.clearTimer('pingTimer')

    this.pingTimer = setInterval(() => {
      if (this.ws?.readyState !== WebSocket.OPEN) {
        console.warn('WebSocket未连接，停止发送ping')
        this.clearTimer('pingTimer')
        this.reconnect()
        return
      }

      try {
        this.ws.send(JSON.stringify({ type: 'ping' }))
        console.debug('发送ping消息')
        // 文章 v4：等 pong 超时视为 TCP 假死，主动断开走重连链路
        this.clearTimer('pongTimer')
        this.pongTimer = setTimeout(() => {
          console.warn('心跳超时未收到响应，主动断连触发重连')
          this.ws?.close(4000, 'Heartbeat timeout')
        }, this.pongTimeout)
      } catch (error) {
        console.error('发送ping消息失败:', error)
        this.clearTimer('pingTimer')
        this.reconnect()
      }
    }, this.pingInterval)
  }

  // 重连 - 增加重连次数限制
  private reconnect(): void {
    if (this.stopReconnect || this.isConnecting || this.reconnectInterval <= 0) {
      return
    }

    // 检查是否超过最大重连次数
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      console.error(`已达到最大重连次数(${this.maxReconnectAttempts})，停止重连`)
      this.close(true)
      return
    }

    this.reconnectAttempts++
    this.isReconnecting = true
    this.closeCurrentSocketForReconnect()

    const delay = this.calculateReconnectDelay()
    console.info(`将在${delay / 1000}秒后尝试重新连接（第${this.reconnectAttempts}/${this.maxReconnectAttempts}次）`)

    this.clearTimer('reconnectTimer')
    this.reconnectTimer = setTimeout(() => {
      console.info(`尝试重新连接WebSocket（第${this.reconnectAttempts}次）`)
      this.connect(false)
    }, delay)
  }

  // 计算重连延迟 - 指数退避策略（文章 v2：1s→2s→4s→…→30s 封顶 + 随机抖动防惊群）
  private calculateReconnectDelay(): number {
    const jitter = Math.random() * 1000 // 0-1秒的随机延迟
    const baseDelay = Math.min(this.reconnectInterval * 2 ** (this.reconnectAttempts - 1), 30_000)
    return baseDelay + jitter
  }

  // 清除指定定时器
  private clearTimer(
    timerName: 'detectionTimer' | 'timeoutTimer' | 'reconnectTimer' | 'pingTimer' | 'pongTimer' | 'connectionTimer'
  ): void {
    if (this[timerName]) {
      clearTimeout(this[timerName] as NodeJS.Timeout)
      this[timerName] = null
    }
  }

  // 清除所有定时器
  private clearAllTimers(): void {
    this.clearConnectionTimers()
    this.clearTimer('reconnectTimer')
  }

  private clearConnectionTimers(): void {
    this.clearTimer('detectionTimer')
    this.clearTimer('timeoutTimer')
    this.clearTimer('pingTimer')
    this.clearTimer('pongTimer')
    this.clearTimer('connectionTimer')
  }

  // 获取当前连接状态
  get isWebSocketConnected(): boolean {
    return this.isConnected
  }

  // 获取当前连接状态文本
  get connectionStatusText(): string {
    if (this.isConnecting) return '正在连接'
    if (this.isConnected) return '已连接'
    if (this.isReconnecting && this.reconnectAttempts > 0)
      return `重连中（${this.reconnectAttempts}/${this.maxReconnectAttempts}）`
    return '已断开'
  }

  /** 网络恢复：重置退避并立即重连（文章 v4） */
  private handleOnline = (): void => {
    console.info('网络恢复，重置退避并立即重连')
    this.reconnectAttempts = 0
    this.clearTimer('reconnectTimer')
    if (!this.stopReconnect && !this.isConnecting && this.ws?.readyState !== WebSocket.OPEN) {
      this.connect(true)
    }
  }

  /** 页面回前台：已连接则立即探测，未连接则重置退避重连（防后台节流导致的静默断连） */
  private handleVisibilityChange = (): void => {
    if (document.visibilityState !== 'visible') return
    if (this.ws?.readyState === WebSocket.OPEN) {
      try {
        this.ws.send(JSON.stringify({ type: 'ping' }))
      } catch {
        // 探测失败由 pong 超时机制接管
      }
    } else if (!this.stopReconnect && !this.isConnecting) {
      console.info('页面回到前台，连接已断开，立即重连')
      this.reconnectAttempts = 0
      this.clearTimer('reconnectTimer')
      this.connect(true)
    }
  }

  // 销毁实例
  static destroyInstance(): void {
    if (WebSocketClient.instance) {
      const inst = WebSocketClient.instance
      if (typeof window !== 'undefined') {
        window.removeEventListener('online', inst.handleOnline)
        document.removeEventListener('visibilitychange', inst.handleVisibilityChange)
      }
      inst.close()
      WebSocketClient.instance = null
    }
  }
}
