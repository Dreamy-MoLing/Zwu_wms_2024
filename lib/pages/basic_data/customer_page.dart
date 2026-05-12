import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/supplier_customer.dart';
import '../../providers/basic_data_provider.dart';
import '../../widgets/data_table_widget.dart';

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
                  color: Colors.white,
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
                      onChanged: (_) => ref.read(customerListProvider.notifier).toggleEnabled(c.id),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Row(
                      children: [
                        TextButton(onPressed: () => _showDialog(context, ref, c), child: const Text('编辑', style: TextStyle(fontSize: 12))),
                        TextButton(onPressed: () => ref.read(customerListProvider.notifier).delete(c.id), child: const Text('删除', style: TextStyle(fontSize: 12, color: Colors.red))),
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
        color: (isVip ? Colors.amber : Colors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(level, style: TextStyle(fontSize: 12, color: isVip ? Colors.amber[800] : Colors.grey)),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('客户管理', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 4),
            Text('管理客户信息与等级', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showDialog(context, ref, null),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新增客户'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context, WidgetRef ref, Customer? customer) {
    final isEdit = customer != null;
    final nameCtrl = TextEditingController(text: customer?.name ?? '');
    final contactCtrl = TextEditingController(text: customer?.contact ?? '');
    final phoneCtrl = TextEditingController(text: customer?.phone ?? '');
    final addressCtrl = TextEditingController(text: customer?.address ?? '');
    String selectedLevel = customer?.level ?? '普通';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(isEdit ? '编辑客户' : '新增客户'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '客户名称', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: contactCtrl, decoration: const InputDecoration(labelText: '联系人', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: '电话', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: '地址', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey(selectedLevel),
                  initialValue: selectedLevel,
                  decoration: const InputDecoration(labelText: '客户等级', border: OutlineInputBorder()),
                  items: ['普通', 'VIP'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                  onChanged: (v) => setState(() => selectedLevel = v!),
                ),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
            ElevatedButton(
              onPressed: () {
                final notifier = ref.read(customerListProvider.notifier);
                final c = Customer(
                  id: isEdit ? customer.id : notifier.generateId(),
                  name: nameCtrl.text, contact: contactCtrl.text, phone: phoneCtrl.text,
                  address: addressCtrl.text, level: selectedLevel,
                );
                if (isEdit) { notifier.update(c); } else { notifier.add(c); }
                Navigator.pop(ctx);
              },
              child: Text(isEdit ? '保存' : '添加'),
            ),
          ],
        ),
      ),
    );
  }
}
