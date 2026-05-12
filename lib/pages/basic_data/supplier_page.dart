import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/supplier_customer.dart';
import '../../providers/basic_data_provider.dart';
import '../../widgets/data_table_widget.dart';

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
                  color: Colors.white,
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
                      onChanged: (_) => ref.read(supplierListProvider.notifier).toggleEnabled(s.id),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Row(
                      children: [
                        TextButton(onPressed: () => _showDialog(context, ref, s), child: const Text('编辑', style: TextStyle(fontSize: 12))),
                        TextButton(onPressed: () => ref.read(supplierListProvider.notifier).delete(s.id), child: const Text('删除', style: TextStyle(fontSize: 12, color: Colors.red))),
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
      decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.teal)),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('供应商管理', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 4),
            Text('管理供应商信息与合作关系', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showDialog(context, ref, null),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新增供应商'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context, WidgetRef ref, Supplier? supplier) {
    final isEdit = supplier != null;
    final nameCtrl = TextEditingController(text: supplier?.name ?? '');
    final contactCtrl = TextEditingController(text: supplier?.contact ?? '');
    final phoneCtrl = TextEditingController(text: supplier?.phone ?? '');
    final addressCtrl = TextEditingController(text: supplier?.address ?? '');
    final categoryCtrl = TextEditingController(text: supplier?.category ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? '编辑供应商' : '新增供应商'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '供应商名称', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: contactCtrl, decoration: const InputDecoration(labelText: '联系人', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: '电话', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: '地址', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: '供应品类', border: OutlineInputBorder())),
            ]),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              final notifier = ref.read(supplierListProvider.notifier);
              final s = Supplier(
                id: isEdit ? supplier.id : notifier.generateId(),
                name: nameCtrl.text, contact: contactCtrl.text, phone: phoneCtrl.text,
                address: addressCtrl.text, category: categoryCtrl.text,
              );
              if (isEdit) { notifier.update(s); } else { notifier.add(s); }
              Navigator.pop(ctx);
            },
            child: Text(isEdit ? '保存' : '添加'),
          ),
        ],
      ),
    );
  }
}
