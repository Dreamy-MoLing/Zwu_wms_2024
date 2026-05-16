import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../providers/purchase_provider.dart';
import '../../providers/basic_data_provider.dart';
import '../../theme/theme.dart';

class SalesReturnPage extends ConsumerWidget {
  const SalesReturnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final returns = ref.watch(salesReturnListProvider);
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
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: returns.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (_, i) {
                    final r = returns[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.error.withValues(alpha: 0.1),
                        child: const Icon(Icons.replay_circle_filled, color: AppColors.error),
                      ),
                      title: Text(r.id, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${r.customerName} · ${r.reason} · ${DateFormat('yyyy-MM-dd').format(r.returnDate)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusChip(r.status),
                          const SizedBox(width: 8),
                          if (r.status == '待处理')
                            TextButton(
                              onPressed: () => ref.read(salesReturnListProvider.notifier).updateStatus(r.id, (sr) => sr.copyWith(status: '已完成')),
                              child: const Text('处理', style: TextStyle(fontSize: 12, color: AppColors.success)),
                            ),
                          TextButton(
                            onPressed: () => ref.read(salesReturnListProvider.notifier).delete(r.id),
                            child: const Text('删除', style: TextStyle(fontSize: 12, color: AppColors.error)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = status == '已完成' ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(fontSize: 12, color: color)),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('销售退货', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text('管理销售退货流程与记录', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showCreateDialog(context, ref),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新建退货'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final customers = ref.read(customerListProvider);
    String selectedCustomer = customers.isNotEmpty ? customers.first.name : '';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('新建销售退货'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  key: ValueKey(selectedCustomer),
                  initialValue: selectedCustomer,
                  decoration: const InputDecoration(labelText: '客户', border: OutlineInputBorder()),
                  items: customers.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
                  onChanged: (v) => setState(() => selectedCustomer = v!),
                ),
                const SizedBox(height: 12),
                const TextField(
                  decoration: InputDecoration(labelText: '退货原因', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
            ElevatedButton(
              onPressed: () {
                final notifier = ref.read(salesReturnListProvider.notifier);
                notifier.add(SalesReturn(
                  id: notifier.generateId(),
                  customerName: selectedCustomer,
                  reason: '客户退货',
                  returnDate: DateTime.now(),
                ));
                Navigator.pop(ctx);
              },
              child: const Text('提交'),
            ),
          ],
        ),
      ),
    );
  }
}
