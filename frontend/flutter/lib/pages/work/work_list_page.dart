import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../common/i18n/app_l10n.dart';
import '../../common/index.dart';
import '../../services/index.dart';

/// 通用工作列表页
///
/// 通过 [columns] 指定展示字段，[fetchPage] 提供分页数据
class _WorkListPage extends StatefulWidget {
  final String title;
  final List<_Column> columns;
  final Future<PageResult<Map<String, dynamic>>> Function({required int page})
  fetchPage;

  const _WorkListPage({
    required this.title,
    required this.columns,
    required this.fetchPage,
  });

  @override
  State<_WorkListPage> createState() => _WorkListPageState();
}

class _WorkListPageState extends State<_WorkListPage> {
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _items = [];

  int _page = 1;
  int _total = 0;
  bool _loading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPage();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_loading &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadPage() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
      _page = 1;
      _items.clear();
      _hasMore = true;
    });
    try {
      final result = await widget.fetchPage(page: 1);
      if (!mounted) return;
      setState(() {
        _items.addAll(result.rows);
        _total = result.total;
        _hasMore = _items.length < _total;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);
    try {
      final result = await widget.fetchPage(page: _page + 1);
      if (!mounted) return;
      setState(() {
        _page++;
        _items.addAll(result.rows);
        _hasMore = _items.length < _total;
      });
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.background,
      appBar: AppTdNavBar(
        title: widget.title,
        background: DesignColors.primary,
        titleColor: Colors.white,
        showBottomLine: false,
        rightBarItems: [
          TDNavBarItem(
            iconWidget: const Icon(Icons.refresh, color: Colors.white),
            action: _loadPage,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPage,
        color: DesignColors.primary,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.r,
              color: DesignColors.textDisabled,
            ),
            SizedBox(height: 12.h),
            Text(
              context.l10n.workLoadFailed,
              style: TextStyle(fontSize: 14.sp, color: DesignColors.textMuted),
            ),
            SizedBox(height: 16.h),
            AppTdButton(
              text: context.l10n.workRetry,
              type: TDButtonType.outline,
              shape: TDButtonShape.square,
              size: TDButtonSize.small,
              onTap: _loadPage,
            ),
          ],
        ),
      );
    }
    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48.r,
              color: DesignColors.textDisabled,
            ),
            SizedBox(height: 12.h),
            Text(
              context.l10n.workEmpty,
              style: TextStyle(fontSize: 14.sp, color: DesignColors.textMuted),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 总数 Header
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              Text(
                context.l10n.workListTotal(total: _total),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: DesignColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: DesignColors.border),
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.all(12.r),
            itemCount: _items.length + (_hasMore ? 1 : 0),
            separatorBuilder: (_, _) => SizedBox(height: 8.h),
            itemBuilder: (_, i) {
              if (i >= _items.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }
              return _ItemCard(item: _items[i], columns: widget.columns);
            },
          ),
        ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<_Column> columns;

  const _ItemCard({required this.item, required this.columns});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columns.asMap().entries.map((e) {
          final idx = e.key;
          final col = e.value;
          final value = _getValue(item, col.key);
          return Padding(
            padding: EdgeInsets.only(top: idx == 0 ? 0 : 6.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 72.w,
                  child: Text(
                    col.label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: DesignColors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  child: idx == 0
                      ? Text(
                          value,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: DesignColors.textPrimary,
                          ),
                        )
                      : _buildValueWidget(context, col, value),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildValueWidget(BuildContext context, _Column col, String value) {
    if (col.type == _ColType.status) {
      final active =
          value == '1' || value == 'true' || value.toLowerCase() == 'normal';
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: (active ? DesignColors.success : DesignColors.error)
              .withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          active
              ? context.l10n.workStatusNormal
              : context.l10n.workStatusDisabled,
          style: TextStyle(
            fontSize: 12.sp,
            color: active ? DesignColors.success : DesignColors.error,
          ),
        ),
      );
    }
    return Text(
      value.isEmpty ? '-' : value,
      style: TextStyle(fontSize: 13.sp, color: DesignColors.textSecondary),
    );
  }

  String _getValue(Map<String, dynamic> item, String key) {
    final keys = key.split('.');
    dynamic val = item;
    for (final k in keys) {
      if (val is Map) {
        val = val[k];
      } else {
        return '';
      }
    }
    return val?.toString() ?? '';
  }
}

enum _ColType { text, status }

class _Column {
  final String label;
  final String key;
  final _ColType type;

  const _Column(this.label, this.key, {this.type = _ColType.text});
}

// ─── 各模块快速工厂 ───────────────────────────────────────────────────────────

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _WorkListPage(
      title: context.l10n.workTitleUser,
      columns: [
        _Column(context.l10n.colUsername, 'username'),
        _Column(context.l10n.colName, 'name'),
        _Column(context.l10n.colPhone, 'phone'),
        _Column(context.l10n.colDept, 'dept_name'),
        _Column(context.l10n.colStatus, 'status', type: _ColType.status),
      ],
      fetchPage: ({required page}) =>
          UserAdminApi.list(params: PageParams(page: page)),
    );
  }
}

class RoleListPage extends StatelessWidget {
  const RoleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _WorkListPage(
      title: context.l10n.workTitleRole,
      columns: [
        _Column(context.l10n.colRoleName, 'name'),
        _Column(context.l10n.colRoleCode, 'code'),
        _Column(context.l10n.colSort, 'sortCode'),
        _Column(context.l10n.colRemark, 'remark'),
      ],
      fetchPage: ({required page}) =>
          RoleApi.list(params: PageParams(page: page)),
    );
  }
}

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _WorkListPage(
      title: context.l10n.workTitleNotice,
      columns: [
        _Column(context.l10n.colTitle, 'title'),
        _Column(context.l10n.colType, 'type'),
        _Column(context.l10n.colPublisher, 'publishUserName'),
        _Column(context.l10n.colPublishTime, 'publishTime'),
      ],
      fetchPage: ({required page}) =>
          NoticeApi.list(params: PageParams(page: page)),
    );
  }
}

class DeptListPage extends StatelessWidget {
  const DeptListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _WorkListPage(
      title: context.l10n.workTitleDept,
      columns: [
        _Column(context.l10n.colDeptName, 'name'),
        _Column(context.l10n.colDeptCode, 'code'),
        _Column(context.l10n.colSort, 'sortCode'),
      ],
      fetchPage: ({required page}) =>
          DeptApi.list(params: PageParams(page: page)),
    );
  }
}

class PositionListPage extends StatelessWidget {
  const PositionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _WorkListPage(
      title: context.l10n.workTitlePosition,
      columns: [
        _Column(context.l10n.colPositionName, 'name'),
        _Column(context.l10n.colPositionCode, 'code'),
        _Column(context.l10n.colSort, 'sortCode'),
      ],
      fetchPage: ({required page}) =>
          PositionApi.list(params: PageParams(page: page)),
    );
  }
}

/// 通用占位页（菜单管理/字典管理/参数管理/日志管理等待接入）
class PlaceholderWorkPage extends StatelessWidget {
  final String title;

  const PlaceholderWorkPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.background,
      appBar: AppTdNavBar(
        title: title,
        background: DesignColors.primary,
        titleColor: Colors.white,
        showBottomLine: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_outlined,
              size: 56.r,
              color: DesignColors.textDisabled,
            ),
            SizedBox(height: 16.h),
            Text(
              context.l10n.commonFeatureDeveloping,
              style: TextStyle(fontSize: 16.sp, color: DesignColors.textMuted),
            ),
            SizedBox(height: 8.h),
            Text(
              context.l10n.workPlaceholderComing(title: title),
              style: TextStyle(
                fontSize: 13.sp,
                color: DesignColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
