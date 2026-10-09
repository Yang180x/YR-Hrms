#!/usr/bin/env node

/**
 * type-check 门禁：跑 vue-tsc，过滤三方依赖（node_modules）自身的类型噪音，
 * 退出码只由本项目 src 下的诊断决定。
 *
 * 背景：wot-ui 2.0.8 的部分 .vue 源码自带类型错误（如 ButtonOpenType/theme），
 * 会经组件引用链进入检查范围，项目侧无法修复且会永久污染门禁输出。
 */
import { spawnSync } from 'node:child_process'
import { createRequire } from 'node:module'
import process from 'node:process'

// 不依赖 PATH 里的 vue-tsc（直接 node 运行时会 ENOENT 且被误判为通过），
// 改为解析本地安装的 bin 入口，用 node 直接执行。
const require = createRequire(import.meta.url)
let vueTscBin
try {
  vueTscBin = require.resolve('vue-tsc/bin/vue-tsc.js')
}
catch {
  console.error('type-check 失败: 未找到 vue-tsc，请先安装依赖（pnpm install）')
  process.exit(1)
}

const res = spawnSync(process.execPath, [vueTscBin, '--noEmit'], { encoding: 'utf8' })

if (res.error) {
  console.error(`type-check 失败: 无法启动 vue-tsc — ${res.error.message}`)
  process.exit(1)
}

const lines = `${res.stdout || ''}${res.stderr || ''}`.split('\n')

const allErrors = lines.filter((l) => l.includes('error TS'))
const thirdParty = allErrors.filter((l) => l.includes('node_modules'))
const projectErrors = allErrors.filter((l) => !l.includes('node_modules'))

// vue-tsc 异常退出却没解析出任何 TS 错误（如配置崩溃），不能假通过
if (res.status !== 0 && allErrors.length === 0) {
  console.error(`type-check 失败: vue-tsc 异常退出 (code ${res.status})`)
  console.error(lines.filter(Boolean).join('\n'))
  process.exit(1)
}

for (const line of projectErrors) {
  console.error(line)
}

if (projectErrors.length > 0) {
  console.error(
    `\ntype-check 失败: ${projectErrors.length} 个项目错误`
      + `（另有 ${thirdParty.length} 个三方依赖噪音已过滤）`,
  )
  process.exit(1)
}

console.log(
  `type-check 通过（src 0 错误，已过滤 ${thirdParty.length} 个三方依赖(wot-ui)自身类型噪音）`,
)
