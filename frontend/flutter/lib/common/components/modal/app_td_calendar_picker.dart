import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../theme/index.dart';

/// 公共 TDesign 日历选择弹框 — 对齐官方 TDCalendarPopup 交互
///
/// ⚠️ fork（0.2.7）的 `tdesign_flutter.dart` 仅导出 `td_calendar.dart`（TDCalendar +
/// CalendarType），**未导出 TDCalendarPopup** → 自建等价弹框：
/// `showModalBottomSheet` + TDCalendar + 底部「确定」按钮。
///
/// 支持 [CalendarType.single]（单选）/ [CalendarType.range]（区间）/ [CalendarType.multiple]（多选）。
/// **默认可选区间从 2000 年起至明年末**（对齐订单历史筛选；可传 [minDate]/[maxDate] 覆盖）。
/// 确认时 [onConfirm] 收到选中日期 `List<int>`（millisecondsSinceEpoch；range 长度 2）。
class AppTdCalendarPicker {
  /// 弹出日历选择（返回值为 pop 完成的 Future；结果经 [onConfirm] 回调）
  static Future<void> show(
    BuildContext context, {
    CalendarType type = CalendarType.single,
    String title = '请选择日期',
    List<int>? value,
    int? minDate,
    int? maxDate,
    bool useTimePicker = false,
    void Function(List<int> value)? onConfirm,
  }) {
    final now = DateTime.now();
    // 默认从 2000 年开始（订单历史可追溯），至明年末
    final min = minDate ?? DateTime(2000).millisecondsSinceEpoch;
    final max =
        maxDate ?? DateTime(now.year + 1, 12, 31).millisecondsSinceEpoch;
    // 初始选中：调用方给定 → 回显；否则默认今天（single 长度 1 / range 由 TDCalendar 补全）
    var selected = (value != null && value.isNotEmpty)
        ? List<int>.of(value)
        : [now.millisecondsSinceEpoch];

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: DesignColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSize.radiusXxl),
        ),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top: DesignSize.spaceSm),
        child: StatefulBuilder(
          builder: (ctx, setSheet) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TDCalendar(
                title: title,
                type: type,
                value: selected,
                minDate: min,
                maxDate: max,
                useTimePicker: useTimePicker,
                height: MediaQuery.of(ctx).size.height * 0.6,
                onChange: (v) {
                  selected = v;
                  setSheet(() {});
                },
              ),
              Padding(
                padding: const EdgeInsets.all(DesignSize.spaceLg),
                child: TDButton(
                  text: '确定', // ok
                  isBlock: true,
                  theme: TDButtonTheme.primary,
                  onTap: () {
                    if (selected.isNotEmpty) onConfirm?.call(selected);
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
