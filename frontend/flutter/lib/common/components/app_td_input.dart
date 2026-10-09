import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../theme/index.dart';

/// 全局 TDesign 输入框（官方 / 胶囊 两种样式）
///
/// 封装 `TDInput`（品牌 TDesign 组件），`isCapsule` 切换两种视觉（**默认官方样式**）：
/// - **官方样式**（默认 `isCapsule: false`，表单页，参考官方 `_basicTypeWithHandleIconThree`）：
///   白底 + 底部下划线（`showBottomDivider: true`），无胶囊背景，对齐 TDesign 官方字段样式
/// - **胶囊样式**（`isCapsule: true`，登录/auth 页显式开启）：52dp 灰底全圆角胶囊，
///   无下划线（`showBottomDivider: false`）、透明背景露出外层灰底胶囊
///   - 独立胶囊：自身绘制灰底全圆角背景（默认，`bare: false`）
///   - 嵌入复合胶囊（验证码行，`bare: true`）：仅渲染透明输入，不绘制灰底/外距，
///     灰底胶囊由外层复合行容器（输入 + 分割线 + 验证码钮）统一承载
/// - 非对称 `contentPadding`（top/bottom）补偿 TextField 顶部对齐 → 文字垂直居中
///   （TDInput 无 `textAlignVertical`，此方案已验证：52dp 高度偏移 -3/-2px）
/// - 清除走 `needClear`（有内容时显示，与 `suffixIcon` 互斥）、后缀走 `suffixIcon`
///
/// 用法示例：
/// ```dart
/// // 默认官方样式（白底 + 底部下划线，表单页）
/// AppTDInput(
///   controller: _phoneCtrl,
///   hint: '请输入手机号',
///   keyboardType: TextInputType.number,
///   maxLength: 11,
///   needClear: true,
/// )
/// // 登录/auth 胶囊样式（显式开启）：
/// AppTDInput(
///   controller: _pwdCtrl,
///   hint: '请输入密码',
///   obscure: true,
///   isCapsule: true,
/// )
/// ```
class AppTDInput extends StatelessWidget {
  /// 输入控制器
  final TextEditingController controller;

  /// 是否胶囊输入框样式（默认 false → 官方样式）
  /// - `false` → 官方 TDInput 字段样式（白底 + 底部下划线，默认，表单页用）
  /// - `true` → 登录/auth 灰底全圆角胶囊（无下划线，露出外层灰底胶囊，显式开启）
  final bool isCapsule;

  /// 是否嵌入已有灰底胶囊容器（验证码行等复合胶囊，默认 false，仅 [isCapsule] 下生效）
  /// - `false` → 胶囊由自身绘制灰底全圆角背景 + 外距（独立胶囊，默认）
  /// - `true` → 仅渲染透明输入（无自身灰底/外距），灰底胶囊由外层复合行容器绘制，
  ///   文字内距走 [capsuleContentPadding]（left 16）与独立胶囊一致
  final bool bare;

  /// 左侧标题（对齐官方 TDInput.leftLabel；label 左 + 输入右，垂直居中）
  final String? leftLabel;

  /// 左侧图标（TDInput leftIcon，默认 24；登录表单前缀图标用）
  final Widget? leftIcon;

  /// 左侧标题样式
  final TextStyle? leftLabelStyle;

  /// 左侧标题与输入间距（默认 null → TDInput 官方 16）
  final double? leftLabelSpace;

  /// 左侧信息区固定宽度（默认 null → 官方按文本自动测量）
  final double? leftInfoWidth;

  /// 标签与内容间距（默认 null → TDInput 官方 labelInputSpace 16）
  /// 表单行对齐用：其他行标签 62dp + 内容间距 8 → 传 8 让输入框内容起点与其他行一致
  final double? labelInputSpace;

  /// 提示文案
  final String hint;

  /// 是否隐藏输入（密码）
  final bool obscure;

  /// 键盘类型
  final TextInputType keyboardType;

  /// 最大长度（自动加 LengthLimitingTextInputFormatter）
  final int? maxLength;

  /// 输入变化回调
  final ValueChanged<String>? onChanged;

  /// 键盘提交回调（回车；登录/搜索等场景用）
  final ValueChanged<String>? onSubmitted;

  /// 是否可用（false → readOnly）
  final bool enabled;

  /// 右侧组件（清除/眼睛/验证码钮；`needClear` 时清除按钮优先）
  final Widget? suffixIcon;

  /// 右侧可点击按钮（密码眼睛等；配合 [onBtnTap]，有值时优先显示、隐藏清除按钮）
  final Widget? rightBtn;

  /// 右侧按钮点击回调
  final GestureTapCallback? onBtnTap;

  /// 单个输入格式器
  final TextInputFormatter? formatter;

  /// 多个输入格式器
  final List<TextInputFormatter>? formatters;

  /// 是否只读
  final bool readOnly;

  /// 点击回调
  final VoidCallback? onTap;

  /// 是否需要右侧清除按钮（有内容时显示；与 suffixIcon 互斥）
  final bool needClear;

  /// 清除按钮图标尺寸（默认 18，与右组件 rightBtn/suffixIcon 一致）
  final double? clearIconSize;

  /// 焦点
  final FocusNode? focusNode;

  /// 输入框高度（默认 52dp，文字 16sp → 居中 padding 自动计算）
  final double height;

  /// 覆盖默认居中 contentPadding
  final EdgeInsetsGeometry? contentPadding;

  /// 输入内容对齐（默认 start；卡号行右对齐用 TextAlign.end）
  final TextAlign contentAlignment;

  /// 输入字体大小（默认 16sp；卡号行与其他行 14sp 一致用 14）
  final double fontSize;

  const AppTDInput({
    super.key,
    required this.controller,
    required this.hint,
    this.isCapsule = false,
    this.bare = false,
    this.leftLabel,
    this.leftIcon,
    this.leftLabelStyle,
    this.leftLabelSpace,
    this.leftInfoWidth,
    this.labelInputSpace,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.suffixIcon,
    this.rightBtn,
    this.onBtnTap,
    this.formatter,
    this.formatters,
    this.readOnly = false,
    this.onTap,
    this.needClear = false,
    this.clearIconSize = 18,
    this.focusNode,
    this.height = 52, // 对齐参考 52dp 输入框高
    this.contentPadding,
    this.contentAlignment = TextAlign.start,
    this.fontSize = 16,
  });

  /// 平台差异化垂直补偿：TDInput 内 TextField 文字对齐各平台不同
  /// - Web：文字贴顶，官方样式 +8 / 胶囊 +4（52dp → 官方 top22/bottom14、胶囊 top20/bottom16，已验证）
  /// - iOS 真机：UITextField 文字天然垂直居中，0（对称 padding，行高用 17）
  /// - Android：实测对称 padding(top18/bottom18) 即可完美居中，0
  ///   （2026-08-11 修正原 +2 → value 比胶囊中心偏下 2px，见 _diag_input_center_test）
  /// 供 AppTDInput 及复用胶囊的 TDInput（验证码行）保持一致
  static double verticalCompensate({bool isCapsule = false}) =>
      kIsWeb ? (isCapsule ? 4.0 : 8.0) : 0.0;

  /// iOS 真机 TextField 文字实际行高 ≈fontSize+1（height:1.0 下 iOS 引擎仍比 fontSize 高约 1px）。
  /// 52dp 容器若按 16 算对称 padding(18+16+18=52 理论刚好)，实际 18+17+18=53 → 底部溢出 1px。
  /// 故 iOS 用 fontSize+1 计算（各 17.5），消除溢出且保持居中；Android/Web 行高即 fontSize。
  static double effectiveLineHeight([double fontSize = 16]) =>
      defaultTargetPlatform == TargetPlatform.iOS ? fontSize + 1.0 : fontSize;

  /// 胶囊模式 contentPadding 统一计算（供 AppTDInput 内部及复用胶囊的 TDInput（验证码行）
  /// 直接使用，避免调用方重复 (height - 行高)/2 ± 补偿 的手工计算，与组件内部保持完全一致）
  /// - [height] 容器高度（默认 52dp，与 [AppTDInput.height] 一致）
  /// - [fontSize] 输入字号（默认 16sp，走 [effectiveLineHeight] 平台行高）
  /// - [left] 左侧 padding（默认 16dp，与胶囊外层灰底左距一致）
  static EdgeInsets capsuleContentPadding({
    double height = 52,
    double fontSize = 16,
    double left = DesignSize.spaceLg,
  }) {
    final textH = effectiveLineHeight(fontSize);
    final compensate = verticalCompensate(isCapsule: true);
    return EdgeInsets.only(
      left: left,
      top: (height - textH) / 2 + compensate,
      bottom: (height - textH) / 2 - compensate,
    );
  }

  /// 胶囊输入框背景 — 灰底全圆角（对齐参考 passwordEditBackground 灰底 radius 26）
  static const BoxDecoration _capsuleDecoration = BoxDecoration(
    color: DesignColors.inputFill,
    borderRadius: BorderRadius.all(Radius.circular(DesignSize.radiusFull)),
  );

  @override
  Widget build(BuildContext context) {
    // 平台差异化文字行高：iOS 真机 TextField 实际行高 ≈fontSize+1（height:1.0 下引擎比 fontSize 高约 1px），
    // 52dp 容器按 fontSize 算理论刚好，实际 +1 → 底部溢出 1px → iOS 用 fontSize+1 计算
    final textH = effectiveLineHeight(fontSize);
    // 平台差异化垂直补偿：TDInput 内 TextField 文字对齐各平台不同（胶囊/官方取值见 verticalCompensate）
    // - Web：文字贴顶，官方 +8 / 胶囊 +4（胶囊 52dp → top20/bottom16，已验证）
    // - iOS/Android：对称 padding 即可垂直居中（iOS 行高用 17，Android 用 16；原 Android +2 已去掉）
    // 胶囊分支不再走 topPad/bottomPad，统一复用 capsuleContentPadding()；此处仅供官方分支使用
    final compensate = verticalCompensate(isCapsule: isCapsule);
    final topPad = (height - textH) / 2 + compensate;
    final bottomPad = (height - textH) / 2 - compensate;
    // 右侧有 suffixIcon/rightBtn/needClear 时容器右 padding 收紧为 0
    // （TDInput rightWidget/rightBtn/清除按钮均自带 right:16 margin 兜底，保证与右缘距离一致）
    final hasRight = suffixIcon != null || rightBtn != null || needClear;
    // 左侧有 leftLabel 时外层左 padding 归零（TDInput 内部 leftLabelSpace ?? 16 自带左间隔），
    //   否则保持 16dp 与无 label 胶囊一致
    final hasLeft = leftLabel != null;
    final hPadding = isCapsule
        // 胶囊模式：左/右 padding 由外层灰底容器承载（无 label → 左16；无右件 → 右16）
        // bare：嵌入复合胶囊，外层行容器统一承载 → 外距归零（文字内距由 contentPadding 承担）
        ? (bare
              ? EdgeInsets.zero
              : EdgeInsets.only(
                  left: hasLeft ? 0.0 : DesignSize.spaceLg,
                  right: hasRight ? 0.0 : DesignSize.spaceLg,
                ))
        // 官方模式：padding 全部交给 TDInput 内部（label 左侧 leftLabelSpace=16 / 输入 left=16），外层不额外加
        : EdgeInsets.zero;
    // 有 leftLabel 时：输入与 label 之间补间隔（官方默认 labelInputSpace=16；默认 contentPadding
    //   仅 top/bottom → left=0 会贴住 label，这里显式补上）；无 label 时保持原 left=0
    // 注意：leftLabelSpace 是 label 左侧间隔（TDInput 内部处理），输入左侧间隔固定 labelInputSpace=16
    // 官方模式：输入 left 恒 16；有右件时 right 收紧为 0（rightWidget 自带 right:16 margin 兜底）
    final inputPadding = isCapsule
        // 胶囊模式：统一走 capsuleContentPadding（独立胶囊 left 由外层容器 hPadding 承载 → 0，
        //   有 leftLabel → 16；bare 容器无外距 → 内容自带 left16）
        ? capsuleContentPadding(
            left: bare
                ? DesignSize.spaceLg
                : (hasLeft ? DesignSize.spaceLg : 0.0),
          )
        : EdgeInsets.only(
            left: DesignSize.spaceLg,
            top: topPad,
            bottom: bottomPad,
            right: hasRight ? 0.0 : DesignSize.spaceLg,
          );
    // 官方模式 + 有 leftLabel：不传 contentPadding，让 TDInput 用默认 getInputPadding()=16，
    //   与 label 的 EdgeInsets.only(top:16, bottom:16) 一致，保证垂直居中对齐
    // 官方模式 + 无 leftLabel：用计算的 topPad/bottomPad 居中
    final effectiveContentPadding = (!isCapsule && hasLeft)
        ? null // TDInput 默认 16/16，与 label 一致
        : (contentPadding ?? inputPadding);
    final input = TDInput(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly || !enabled,
      obscureText: obscure,
      inputType: keyboardType,
      inputFormatters: [
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength!),
        if (formatter != null) formatter!,
        ...?formatters,
      ],
      leftLabel: leftLabel,
      leftIcon: leftIcon,
      // label 默认 height:1.0 匹配 input 行高（TDText 默认用 fontBodyLarge lineHeight24→height1.5，会导致 label 偏下）
      leftLabelStyle:
          leftLabelStyle ??
          TextStyle(fontSize: fontSize, height: 1.0, letterSpacing: 0),
      leftLabelSpace: leftLabelSpace,
      leftInfoWidth: leftInfoWidth,
      // labelInputSpace 自定义时透传 TDInputSpacer（其余保持官方默认）
      spacer: labelInputSpace != null
          ? TDInputSpacer(labelInputSpace: labelInputSpace, inputRightSpace: 16)
          : null,
      contentAlignment: contentAlignment,
      hintText: hint,
      hintTextStyle: TextStyle(
        fontSize: fontSize,
        height: 1.0,
        color: DesignColors.textDisabled,
      ),
      textStyle: TextStyle(
        fontSize: fontSize,
        height: 1.0,
        color: DesignColors.textPrimary,
      ),
      // 胶囊→透明背景露出外层灰底胶囊；官方→null 走 TDInput 白底（bgColorContainer）+ 底部下划线
      backgroundColor: isCapsule ? Colors.transparent : null,
      contentPadding: effectiveContentPadding,
      showBottomDivider: !isCapsule,
      needClear: needClear,
      clearIconSize: clearIconSize,
      onClearTap: () {
        controller.clear();
        onChanged?.call('');
      },
      rightWidget: suffixIcon,
      rightBtn: rightBtn,
      onBtnTap: onBtnTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
    // 独立胶囊才由自身绘制灰底背景（bare 嵌入复合胶囊时不绘制，露出外层容器灰底）
    // 注意：onTap 分支沿用原 isCapsule 判断；非 onTap 分支沿用原「无条件灰底」——两者仅对 bare 收窄
    final hasCapsuleBg = isCapsule && !bare;
    // onTap 用 GestureDetector 包装（TDInput 无 onTap 参数，兼容 AuthTextField.onTap）
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          padding: hPadding,
          decoration: hasCapsuleBg
              ? _capsuleDecoration
              : null, // 胶囊→灰底全圆角；官方/bare→无背景
          child: input,
        ),
      );
    }
    return Container(
      height: height,
      padding: hPadding,
      decoration: bare ? null : _capsuleDecoration, // 灰底全圆角胶囊（bare 嵌入时由外层容器承载）
      child: input,
    );
  }
}
