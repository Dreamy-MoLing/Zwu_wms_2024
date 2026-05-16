import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/basic_data_provider.dart';
import '../../widgets/data_table_widget.dart';
import '../../widgets/form_dialogs/supplier_form_dialog.dart';
import '../../theme/theme.dart';

class SupplierPage extends ConsumerWidget {
  const SupplierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliers = ref.watch(supplierListProvider);
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
                    DataColumn(label: Text('供应商名称')),
                    DataColumn(label: Text('联系人')),
                    DataColumn(label: Text('电话')),
                    DataColumn(label: Text('地址')),
                    DataColumn(label: Text('分类')),
                    DataColumn(label: Text('状态')),
                    DataColumn(label: Text('操作')),
                  ],
                  rows: suppliers.map((s) => DataRow(cells: [
                    DataCell(Text(s.id)),
                    DataCell(Text(s.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text(s.contact)),
                    DataCell(Text(s.phone)),
                    DataCell(SizedBox(width: 150, child: Text(s.address, overflow: TextOverflow.ellipsis))),
                    DataCell(_buildChip(s.category)),
                    DataCell(Switch(
                      value: s.enabled,
                      onChanged: (_) => ref.read(supplierListProvider.notifier).toggleEnabled(s.id, (e) => e.copyWith(enabled: !e.enabled)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Row(
                      children: [
                        TextButton(onPressed: () => SupplierFormDialog.show(context, supplier: s), child: const Text('编辑', style: TextStyle(fontSize: 12))),
                        TextButton(onPressed: () => ref.read(supplierListProvider.notifier).delete(s.id), child: const Text('删除', style: TextStyle(fontSize: 12, color: AppColors.error))),
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

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: AppColors.completed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.completed)),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('供应商管理', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text('管理供应商信息与合作关系', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => SupplierFormDialog.show(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新增供应商'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

}
