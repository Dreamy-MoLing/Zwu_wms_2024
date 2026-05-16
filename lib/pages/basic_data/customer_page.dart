import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/basic_data_provider.dart';
import '../../widgets/data_table_widget.dart';
import '../../widgets/form_dialogs/customer_form_dialog.dart';
import '../../theme/theme.dart';

class CustomerPage extends ConsumerWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customerListProvider);
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
                    DataColumn(label: Text('客户名称')),
                    DataColumn(label: Text('联系人')),
                    DataColumn(label: Text('电话')),
                    DataColumn(label: Text('地址')),
                    DataColumn(label: Text('等级')),
                    DataColumn(label: Text('状态')),
                    DataColumn(label: Text('操作')),
                  ],
                  rows: customers.map((c) => DataRow(cells: [
                    DataCell(Text(c.id)),
                    DataCell(Text(c.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text(c.contact)),
                    DataCell(Text(c.phone)),
                    DataCell(SizedBox(width: 150, child: Text(c.address, overflow: TextOverflow.ellipsis))),
                    DataCell(_buildLevelChip(c.level)),
                    DataCell(Switch(
                      value: c.enabled,
                      onChanged: (_) => ref.read(customerListProvider.notifier).toggleEnabled(c.id, (e) => e.copyWith(enabled: !e.enabled)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Row(
                      children: [
                        TextButton(onPressed: () => CustomerFormDialog.show(context, customer: c), child: const Text('编辑', style: TextStyle(fontSize: 12))),
                        TextButton(onPressed: () => ref.read(customerListProvider.notifier).delete(c.id), child: const Text('删除', style: TextStyle(fontSize: 12, color: AppColors.error))),
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

  Widget _buildLevelChip(String level) {
    final isVip = level == 'VIP';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: (isVip ? AppColors.warning : AppColors.textSecondary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(level, style: TextStyle(fontSize: 12, color: isVip ? AppColors.warning : AppColors.textSecondary)),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('客户管理', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text('管理客户信息与等级', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => CustomerFormDialog.show(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新增客户'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

}
