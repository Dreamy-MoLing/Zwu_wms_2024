import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/basic_data_provider.dart';
import '../../widgets/data_table_widget.dart';
import '../../widgets/form_dialogs/warehouse_form_dialog.dart';
import '../../theme/theme.dart';

class WarehousePage extends ConsumerWidget {
  const WarehousePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warehouses = ref.watch(warehouseListProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgPrimary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
                ),
                child: DataTableWidget(
                  columns: const [
                    DataColumn(label: Text('编号')),
                    DataColumn(label: Text('仓库名称')),
                    DataColumn(label: Text('联系人')),
                    DataColumn(label: Text('电话')),
                    DataColumn(label: Text('地址')),
                    DataColumn(label: Text('状态')),
                    DataColumn(label: Text('操作')),
                  ],
                  rows: warehouses.map((w) => DataRow(cells: [
                    DataCell(Text(w.id)),
                    DataCell(Text(w.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text(w.contact)),
                    DataCell(Text(w.phone)),
                    DataCell(SizedBox(width: 150, child: Text(w.address, overflow: TextOverflow.ellipsis))),
                    DataCell(Switch(
                      value: w.enabled,
                      onChanged: (_) => ref.read(warehouseListProvider.notifier).toggleEnabled(w.id, (e) => e.copyWith(enabled: !e.enabled)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Row(
                      children: [
                        TextButton(onPressed: () => WarehouseFormDialog.show(context, warehouse: w), child: const Text('编辑', style: TextStyle(fontSize: 12))),
                        TextButton(onPressed: () => ref.read(warehouseListProvider.notifier).delete(w.id), child: const Text('删除', style: TextStyle(fontSize: 12, color: AppColors.error))),
                      ],
                    )),
                  ])).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('仓库管理', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text('管理仓库信息与库位', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => WarehouseFormDialog.show(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新增仓库'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

}
