import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../providers/purchase_provider.dart';
import '../../providers/basic_data_provider.dart';

class PurchaseReturnPage extends ConsumerWidget {
  const PurchaseReturnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final returns = ref.watch(purchaseReturnListProvider);
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
                  color: Colors.white,
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
                        backgroundColor: Colors.orange.withValues(alpha: 0.1),
                        child: const Icon(Icons.replay, color: Colors.orange),
                      ),
                      title: Text(r.id, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${r.supplierName} · ${r.reason} · ${DateFormat('yyyy-MM-dd').format(r.returnDate)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusChip(r.status),
                          const SizedBox(width: 8),
                          if (r.status == '待处理')
                            TextButton(
                              onPressed: () => ref.read(purchaseReturnListProvider.notifier).updateStatus(r.id, '已完成'),
                              child: const Text('处理', style: TextStyle(fontSize: 12, color: Colors.green)),
                            ),
                          TextButton(
                            onPressed: () => ref.read(purchaseReturnListProvider.notifier).delete(r.id),
                            child: const Text('删除', style: TextStyle(fontSize: 12, color: Colors.red)),
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
    final color = status == '已完成' ? Colors.green : Colors.orange;
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('采购退货', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 4),
            Text('管理采购退货流程与记录', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showCreateDialog(context, ref),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新建退货'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final suppliers = ref.read(supplierListProvider);
    String selectedSupplier = suppliers.isNotEmpty ? suppliers.first.name : '';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('新建采购退货'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  key: ValueKey(selectedSupplier),
                  initialValue: selectedSupplier,
                  decoration: const InputDecoration(labelText: '供应商', border: OutlineInputBorder()),
                  items: suppliers.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
                  onChanged: (v) => setState(() => selectedSupplier = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(labelText: '退货原因', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
            ElevatedButton(
              onPressed: () {
                final notifier = ref.read(purchaseReturnListProvider.notifier);
                notifier.add(PurchaseReturn(
                  id: notifier.generateId(),
                  supplierName: selectedSupplier,
                  reason: '商品质量问题',
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
