import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/supplier_customer.dart';
import '../../providers/basic_data_provider.dart';

class CustomerFormDialog extends ConsumerStatefulWidget {
  final Customer? customer;

  const CustomerFormDialog({super.key, this.customer});

  static Future<void> show(BuildContext context, {Customer? customer}) {
    return showDialog<void>(
      context: context,
      builder: (_) => CustomerFormDialog(customer: customer),
    );
  }

  @override
  ConsumerState<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends ConsumerState<CustomerFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _contactCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late String _selectedLevel;

  bool get _isEdit => widget.customer != null;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _contactCtrl = TextEditingController(text: c?.contact ?? '');
    _phoneCtrl = TextEditingController(text: c?.phone ?? '');
    _addressCtrl = TextEditingController(text: c?.address ?? '');
    _selectedLevel = c?.level ?? '普通';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contactCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? '编辑客户' : '新增客户'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: '客户名称', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _contactCtrl, decoration: const InputDecoration(labelText: '联系人', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: '电话', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _addressCtrl, decoration: const InputDecoration(labelText: '地址', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedLevel,
              decoration: const InputDecoration(labelText: '客户等级', border: OutlineInputBorder()),
              items: ['普通', 'VIP'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (v) => setState(() => _selectedLevel = v!),
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
        ElevatedButton(onPressed: _submit, child: Text(_isEdit ? '保存' : '添加')),
      ],
    );
  }

  void _submit() {
    final notifier = ref.read(customerListProvider.notifier);
    final c = Customer(
      id: _isEdit ? widget.customer!.id : notifier.generateId(),
      name: _nameCtrl.text, contact: _contactCtrl.text, phone: _phoneCtrl.text,
      address: _addressCtrl.text, level: _selectedLevel,
    );
    if (_isEdit) { notifier.update(c); } else { notifier.add(c); }
    Navigator.pop(context);
  }
}
