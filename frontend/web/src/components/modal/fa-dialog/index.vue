<template>
  <ElDialog
    v-model="visible"
    :width="width"
    :draggable="draggable"
    :fullscreen="fullscreen"
    :show-close="false"
    :class="dialogClass"
    :modal-class="modalClass"
    align-center
    destroy-on-close
    v-bind="dialogAttrs"
    @close="emit('close')"
    @closed="emit('closed')"
    @opened="emit('opened')">
    <template #header="{ titleId, titleClass, close }">
      <div class="core-overlay-dialog__header">
        <span :id="titleId" :class="titleClass">{{ title }}</span>
        <div class="core-overlay-dialog__actions">
          <ElTooltip :content="fullscreen ? '还原' : '全屏'" placement="top">
            <ElButton class="core-overlay-icon-btn" text type="primary" @click="fullscreen = !fullscreen">
              <ElIcon>
                <Fold v-if="fullscreen" />
                <FullScreen v-else />
              </ElIcon>
            </ElButton>
          </ElTooltip>
          <ElTooltip content="关闭" placement="top">
            <ElButton class="core-overlay-icon-btn" text @click="close">
              <ElIcon><Close /></ElIcon>
            </ElButton>
          </ElTooltip>
        </div>
      </div>
    </template>
    <slot />
    <template v-if="$slots.footer" #footer>
      <slot name="footer" />
    </template>
    <!-- 表单模式默认底部按钮（页面未提供 footer slot 时生效）：
         detail 仅显示关闭；create/update 显示取消+确定 -->
    <template v-else-if="formMode" #footer>
      <div class="fa-dialog-footer" :style="'padding-right: var(--el-dialog-padding-primary)'">
        <!-- detail 模式仅显示关闭按钮，emit close 以区分语义 -->
        <ElButton v-if="formMode === 'detail'" type="primary" @click="emit('close')">
          {{ confirmText || '关闭' }}
        </ElButton>
        <template v-else>
          <ElButton type="primary" plain @click="emit('cancel')">
            {{ cancelText }}
          </ElButton>
          <!-- 创建模式支持"提交并继续添加" -->
          <ElButton
            v-if="showSubmitAndContinue && formMode === 'create'"
            type="primary"
            :loading="confirmLoading"
            @click="emit('submitAndContinue')">
            提交并继续添加
          </ElButton>
          <ElButton type="primary" :loading="confirmLoading" @click="emit('confirm')">
            {{ confirmText }}
          </ElButton>
        </template>
      </div>
    </template>
  </ElDialog>
</template>

<script setup lang="ts">
import { Close, Fold, FullScreen } from '@element-plus/icons-vue'
import type { DialogProps } from 'element-plus'
import { computed, onMounted, onUnmounted, ref, useAttrs, watch } from 'vue'

defineOptions({ name: 'FaDialog', inheritAttrs: false })

const props = withDefaults(
  defineProps<{
    modelValue: boolean
    title?: string
    width?: string | number
    /** 默认可拖拽；全屏时 Element Plus 会限制拖拽 */
    draggable?: boolean
    /** 透传到 el-dialog 的 class */
    dialogClass?: string
    /** 遮罩层自定义 class */
    modalClass?: string
    /** 表单模式：detail 仅显示关闭；create/update 显示取消+确定 */
    formMode?: 'detail' | 'create' | 'update'
    /** 确定按钮 loading 状态 */
    confirmLoading?: boolean
    /** 确定按钮文本 */
    confirmText?: string
    /** 取消按钮文本 */
    cancelText?: string
    /** 是否显示"提交并继续添加"按钮（仅 create 模式有效） */
    showSubmitAndContinue?: boolean
  }>(),
  {
    draggable: true,
    confirmText: '确定',
    cancelText: '取消',
    showSubmitAndContinue: false,
  }
)

const emit = defineEmits<{
  'update:modelValue': [v: boolean]
  close: []
  closed: []
  opened: []
  'fullscreen-change': [isFullscreen: boolean]
  /** 点击取消按钮 */
  cancel: []
  /** 点击确定按钮 */
  confirm: []
  /** 点击提交并继续添加按钮 */
  submitAndContinue: []
}>()

const attrs = useAttrs()
const fullscreen = ref(false)

watch(fullscreen, (newVal) => {
  emit('fullscreen-change', newVal)
})

/** Ctrl+Enter / Cmd+Enter 快捷键触发确认提交（非 detail 模式） */
function onKeydown(e: KeyboardEvent) {
  if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
    if (props.modelValue && props.formMode && props.formMode !== 'detail') {
      e.preventDefault()
      emit('confirm')
    }
  }
}

onMounted(() => window.addEventListener('keydown', onKeydown))
onUnmounted(() => window.removeEventListener('keydown', onKeydown))

const dialogClass = computed(() => {
  const a = attrs.class
  return [props.dialogClass, a].filter(Boolean)
})

const visible = computed({
  get: () => props.modelValue,
  set: (v: boolean) => emit('update:modelValue', v),
})

/** 透传除 modelValue 外的 el-dialog 属性（如 top、modal-class、append-to-body 等） */
const dialogAttrs = computed(() => {
  const a = { ...attrs } as Record<string, unknown>
  delete a.class
  return a as Partial<Omit<DialogProps, 'modelValue'>>
})
</script>

<style scoped lang="scss">
.core-overlay-dialog__header {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  padding-right: 4px;
}

.core-overlay-dialog__actions {
  display: inline-flex;
  flex-shrink: 0;
  gap: 4px;
  align-items: center;
  margin-left: auto;

  :deep(.core-overlay-icon-btn.el-button) {
    min-width: 32px;
    padding: 6px;
    border-radius: var(--el-border-radius-base);

    &.is-text:not(.is-disabled):hover {
      border-radius: var(--el-border-radius-base);
    }
  }
}
</style>
