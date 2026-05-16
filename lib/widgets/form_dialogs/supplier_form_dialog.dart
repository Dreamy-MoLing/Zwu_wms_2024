import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/supplier_customer.dart';
import '../../providers/basic_data_provider.dart';

class SupplierFormDialog extends ConsumerStatefulWidget {
  final Supplier? supplier;

  const SupplierFormDialog({super.key, this.supplier});

  static Future<void> show(BuildContext context, {Supplier? supplier}) {
    return showDialog<void>(
      context: context,
      builder: (_) => SupplierFormDialog(supplier: supplier),
    );
  }

  @override
  ConsumerState<SupplierFormDialog> createState() => _SupplierFormDialogState();
}

class _SupplierFormDialogState extends ConsumerState<SupplierFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _contactCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _categoryCtrl;

  bool get _isEdit => widget.supplier != null;

  @override
  void initState() {
    super.initState();
    final s = widget.supplier;
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _contactCtrl = TextEditingController(text: s?.contact ?? '');
    _phoneCtrl = TextEditingController(text: s?.phone ?? '');
    _addressCtrl = TextEditingController(text: s?.address ?? '');
    _categoryCtrl = TextEditingController(text: s?.category ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contactCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? '编辑供应商' : '新增供应商'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: '供应商名称', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _contactCtrl, decoration: const InputDecoration(labelText: '联系人', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: '电话', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _addressCtrl, decoration: const InputDecoration(labelText: '地址', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _categoryCtrl, decoration: const InputDecoration(labelText: '供应品类', border: OutlineInputBorder())),
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
    final notifier = ref.read(supplierListProvider.notifier);
    final s = Supplier(
      id: _isEdit ? widget.supplier!.id : notifier.generateId(),
      name: _nameCtrl.text, contact: _contactCtrl.text, phone: _phoneCtrl.text,
      address: _addressCtrl.text, category: _categoryCtrl.text,
    );
    if (_isEdit) { notifier.update(s); } else { notifier.add(s); }
    Navigator.pop(context);
  }
}
