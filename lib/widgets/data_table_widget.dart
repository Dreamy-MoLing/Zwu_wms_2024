import 'package:flutter/material.dart';
import '../theme/theme.dart';

class DataTableWidget extends StatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool loading;
  final String? emptyMessage;

  const DataTableWidget({
    super.key,
    required this.columns,
    required this.rows,
    this.loading = false,
    this.emptyMessage,
  });

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
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
            Icon(Icons.inbox, size: 48, color: AppColors.textTertiary),
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

    return SingleChildScrollView(
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
          rows: widget.rows,
        ),
      ),
    );
  }
}
