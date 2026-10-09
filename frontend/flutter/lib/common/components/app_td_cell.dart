import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../theme/index.dart';

/// 统一 TDCell 封装 — 全局统一样式出口
///
/// 抽取自各页面散落的 `TDCellStyle.cellStyle(context)..padding=...` + 自定义箭头：
/// - **高度自适应（默认 null）**：cell 高度 = padding + 内容自然高度 —— 16sp 基础字号单行
///   自然 48dp（对齐 FastapiAdmin 4px 体系）；多行/长内容自适应撑高，杜绝固定高度溢出。
///   特例（头像行等）显式传 height 固定
/// - **紧凑行 padding**：垂直 padding s12（内容区 = 高度-24；动态高度下由内容自然撑起，无溢出）
/// - **行 padding 唯一出口**：水平 `DesignSize.spaceLg` + 垂直 `DesignSize.spaceMd`（统一视觉），
///   页面内行一律走本组件，禁止手写行 padding
/// - **原生右箭头**：`arrow: true` 用 TDIcons.chevron_right，替代手写箭头
///
/// 用法：
/// ```dart
/// AppTdCell(
///   leftIconWidget: Image.asset(...), // 默认高度自适应（16sp 单行自然 48dp），非特例无需传 height
///   title: '标题',
///   rightIconWidget: badge, // trailing 内容（非箭头）
///   arrow: true,            // 原生右箭头
///   onTap: () => ...,
///   showBottomBorder: true,
/// )
/// // 特例（头像行等）才显式覆盖：
/// AppTdCell(
///   height: DesignSize.avatarMd,
///   title: '头像',
/// )
/// ```
class AppTdCell extends StatelessWidget {
  /// 行高（默认 null → 高度自适应：padding + 内容自然高度）
  ///
  /// ⚠️ 不要固定 48 硬塞 16sp 文字：TDCell 内容区 = height - 垂直padding(24) - 0.5 结构开销
  ///   = 23.5，而 16sp 行高 24 → 溢出 0.5px（RenderFlex bottom overflow）。
  ///   高度留 null 让内容自然撑起（24 + 24 = 48，对齐 4px 体系且不溢出）。
  final double? height;
  final Widget? leftIconWidget;
  final String? title;
  final Widget? titleWidget;
  final String? description;
  final Widget? descriptionWidget;
  final Widget? rightIconWidget;

  /// 右侧 trailing 文本 — 防溢出安全出口
  ///
  /// 使用 TDCell 的 `noteWidget` 槽位（Wrap 内 noteWidget 先于 rightIconWidget/arrow 占位），
  /// maxWidth 限屏宽 45%（~175px/390 屏），确保标题区 ≥100px 不被挤压。
  /// 单行省略兜底：长值（脱敏证号/电话/认证失败原因等）自动截断 + 省略号。
  final String? trailingText;

  /// trailing 文本样式（默认 14sp secondary，对齐 cell 右值）
  final TextStyle? trailingTextStyle;
  final bool arrow;
  final VoidCallback? onTap;
  final TDCellClick? onLongPress;
  final bool showBottomBorder;
  final TDCellAlign? align;

  const AppTdCell({
    super.key,
    this.height, // 默认 null → 高度自适应（16sp 单行自然 48dp）；特例显式固定
    this.leftIconWidget,
    this.title,
    this.titleWidget,
    this.description,
    this.descriptionWidget,
    this.rightIconWidget,
    this.trailingText,
    this.trailingTextStyle,
    this.arrow = false,
    this.onTap,
    this.onLongPress,
    this.showBottomBorder = true,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ 全局统一样式（高度自适应，垂直 padding s12）
    //   行 padding 唯一出口：水平 spaceLg + 垂直 spaceMd。
    //   高度不固定（height null）→ 由 padding + 内容自然高度决定：16sp 单行 = 24+24 = 48dp，
    //   对齐 4px 体系且杜绝固定高度下 16sp 行高 24 > 内容区 23.5 的 0.5px 溢出。
    //   titleStyle 颜色对齐 DesignColors.textPrimary —— 使 `title:` 字符串参数渲染
    //   与 `titleWidget: Text(..., style: TextStyle(color: textPrimary, fontSize: 16))` 视觉一致，
    //   简单文本调用方直接用 `title:` 即可，无需重新构建 titleWidget
    final style = TDCellStyle.cellStyle(context)
      ..padding = const EdgeInsets.fromLTRB(
        DesignSize.spaceLg,
        DesignSize.spaceMd,
        DesignSize.spaceLg,
        DesignSize.spaceMd,
      );
    style.titleStyle =
        style.titleStyle?.copyWith(color: DesignColors.textPrimary) ??
        TextStyle(
          color: DesignColors.textPrimary,
          fontSize: DesignTextStyle.titleMd.fontSize,
        );
    return TDCell(
      height: height,
      style: style,
      leftIconWidget: leftIconWidget,
      title: title,
      titleWidget: titleWidget,
      description: description,
      descriptionWidget: descriptionWidget,
      // ✅ trailingText → noteWidget（TDCell note 内置 maxWidth 防溢出）：
      //   原方案把 trailingText 放进 rightIconWidget（Wrap 内无宽度约束），长文本
      //   撑满 Wrap → Expanded title Column 被挤压到 w=24 → 垂直溢出 102px。
      //   改用 noteWidget：TDCell Wrap 内 noteWidget 先占位，再排 rightIconWidget + arrow，
      //   maxWidth 限屏宽 45%（~175px/390屏），留足标题区 ≥100px。
      //   rightIconWidget 保持原值（info 图标等），与 noteWidget 在 Wrap 内独立排列。
      noteWidget: trailingText != null
          ? ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.45,
              ),
              child: Text(
                trailingText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    trailingTextStyle ??
                    TextStyle(
                      fontSize: DesignTextStyle.body.fontSize,
                      color: DesignColors.textSecondary,
                    ),
              ),
            )
          : null,
      rightIconWidget: rightIconWidget,
      arrow: arrow, // ✅ TD 原生箭头（TDIcons.chevron_right）
      onClick: onTap == null ? null : (_) => onTap!(),
      onLongPress: onLongPress,
      showBottomBorder: showBottomBorder,
      align: align,
    );
  }
}
