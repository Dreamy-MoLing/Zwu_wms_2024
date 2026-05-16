import 'package:flutter/material.dart';
import '../theme/theme.dart';

class DataTableWidget extends StatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool loading;
  final String? emptyMessage;
  final int rowsPerPage;

  const DataTableWidget({
    super.key,
    required this.columns,
    required this.rows,
    this.loading = false,
    this.emptyMessage,
    this.rowsPerPage = 15,
  });

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  int _page = 0;

  int get _totalPages => (widget.rows.length / widget.rowsPerPage).ceil().clamp(1, 9999);

  List<DataRow> _currentRows() {
    final start = _page * widget.rowsPerPage;
    final end = (start + widget.rowsPerPage).clamp(0, widget.rows.length);
    return widget.rows.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '加载中...',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (widget.rows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: AppSpacing.lg),
            Text(
              widget.emptyMessage ?? '暂无数据',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_page >= _totalPages) _page = _totalPages - 1;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Theme(
              data: Theme.of(context).copyWith(
                dataTableTheme: DataTableThemeData(
                  headingRowColor: WidgetStateColor.resolveWith(
                    (_) => AppColors.bgTertiary,
                  ),
                  dataRowColor: WidgetStateColor.resolveWith((_) {
                    return AppColors.bgPrimary;
                  }),
                  headingRowHeight: AppSpacing.heightTableRow,
                  dataRowMinHeight: AppSpacing.heightTableRow,
                  dataRowMaxHeight: AppSpacing.heightTableRow,
                  columnSpacing: AppSpacing.lg,
                  horizontalMargin: AppSpacing.lg,
                  headingTextStyle: AppTypography.h6.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  dataTextStyle: AppTypography.bodyMedium,
                  dividerThickness: AppSpacing.borderNormal,
                ),
              ),
              child: DataTable(
                columnSpacing: AppSpacing.lg,
                horizontalMargin: AppSpacing.lg,
                columns: widget.columns,
                rows: _currentRows(),
              ),
            ),
          ),
        ),
        if (_totalPages > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.borderDefault)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${_page * widget.rowsPerPage + 1}-${((_page + 1) * widget.rowsPerPage).clamp(0, widget.rows.length)} / 共 ${widget.rows.length} 条',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: _page > 0 ? () => setState(() => _page--) : null,
                  visualDensity: VisualDensity.compact,
                  tooltip: '上一页',
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: _page < _totalPages - 1 ? () => setState(() => _page++) : null,
                  visualDensity: VisualDensity.compact,
                  tooltip: '下一页',
                ),
              ],
            ),
          ),
      ],
    );
  }
}
