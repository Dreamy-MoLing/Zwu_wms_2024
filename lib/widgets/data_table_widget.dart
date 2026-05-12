import 'package:flutter/material.dart';

class DataTableWidget extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool loading;

  const DataTableWidget({
    super.key,
    required this.columns,
    required this.rows,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (rows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text('暂无数据', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Theme(
        data: Theme.of(context).copyWith(
          dataTableTheme: const DataTableThemeData(
            headingRowHeight: 48,
            dataRowMinHeight: 48,
            dataRowMaxHeight: 48,
            headingTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
            dataTextStyle: TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
        child: DataTable(
          columnSpacing: 24,
          horizontalMargin: 16,
          columns: columns,
          rows: rows,
        ),
      ),
    );
  }
}
