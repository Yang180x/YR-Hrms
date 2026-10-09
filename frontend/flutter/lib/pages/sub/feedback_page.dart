import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../common/i18n/app_l10n.dart';
import '../../common/index.dart';
import '../../l10n/generated/app_localizations.dart';

/// 问题反馈页
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

/// 反馈类型（稳定枚举，显示文案走 l10n，避免按本地化字符串比较）
enum _FeedbackType { bug, ui, perf, suggestion, other }

class _FeedbackPageState extends State<FeedbackPage> {
  final _contentCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  _FeedbackType _selectedType = _FeedbackType.bug;
  bool _submitting = false;

  String _typeLabel(_FeedbackType type, AppLocalizations l10n) {
    switch (type) {
      case _FeedbackType.bug:
        return l10n.feedbackTypeBug;
      case _FeedbackType.ui:
        return l10n.feedbackTypeUi;
      case _FeedbackType.perf:
        return l10n.feedbackTypePerf;
      case _FeedbackType.suggestion:
        return l10n.feedbackTypeSuggestion;
      case _FeedbackType.other:
        return l10n.feedbackTypeOther;
    }
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_contentCtrl.text.trim().isEmpty) {
      TDToast.showText(context.l10n.feedbackContentEmpty, context: context);
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      TDToast.showText(context.l10n.feedbackThanks, context: context);
      _contentCtrl.clear();
      _contactCtrl.clear();
      setState(() {
        _submitting = false;
        _selectedType = _FeedbackType.bug;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.background,
      appBar: AppTdNavBar(
        title: context.l10n.feedbackTitle,
        background: DesignColors.primary,
        titleColor: Colors.white,
        showBottomLine: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard(
              children: [
                _buildLabel(context.l10n.feedbackType),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _FeedbackType.values.map((t) {
                    final selected = _selectedType == t;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedType = t),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? DesignColors.primary
                              : DesignColors.inputFill,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          _typeLabel(t, context.l10n),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: selected
                                ? Colors.white
                                : DesignColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),
                _buildLabel(context.l10n.feedbackContent),
                SizedBox(height: 8.h),
                TextField(
                  controller: _contentCtrl,
                  maxLines: 6,
                  maxLength: 500,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: DesignColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: context.l10n.feedbackContentHint,
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: DesignColors.textDisabled,
                    ),
                    filled: true,
                    fillColor: DesignColors.inputFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(12.r),
                  ),
                ),
                SizedBox(height: 12.h),
                _buildLabel(context.l10n.feedbackContact),
                SizedBox(height: 8.h),
                TextField(
                  controller: _contactCtrl,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: DesignColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: context.l10n.feedbackContactHint,
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: DesignColors.textDisabled,
                    ),
                    filled: true,
                    fillColor: DesignColors.inputFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            AppTdButton(
              text: _submitting
                  ? context.l10n.commonSubmitting
                  : context.l10n.feedbackSubmit,
              isBlock: true,
              height: 46,
              disabled: _submitting,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: DesignColors.textSecondary,
      ),
    );
  }
}
