<script setup lang="ts">
import { http } from '@/http'
import { onLoad } from '@dcloudio/uni-app'
import { ref } from 'vue'

definePage({ name: 'test-http', style: { navigationBarTitleText: 'HTTP测试' } })
const msg = ref('加载中')
const result = ref('')

onLoad(async () => {
  msg.value = '开始测试...'
  try {
    // 白名单接口（无需登录），验证主栈请求链路连通性
    const res = await http.Get('/system/auth/captcha/get', { query: { timestamp: Date.now() } })
    result.value = `成功: ${JSON.stringify(res).substring(0, 100)}`
  } catch (e: any) {
    result.value = `错误: ${e?.message || String(e)}`
  }
  msg.value = '完成'
})
</script>
<template>
  <view style="padding: 40rpx">
    <text style="font-size: 32rpx">{{ msg }}</text>
    <text style="font-size: 28rpx; display: block; margin-top: 20rpx">{{ result }}</text>
  </view>
</template>
