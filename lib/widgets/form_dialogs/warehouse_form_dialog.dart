import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/warehouse.dart';
import '../../providers/basic_data_provider.dart';

class WarehouseFormDialog extends ConsumerStatefulWidget {
  final Warehouse? warehouse;

  const WarehouseFormDialog({super.key, this.warehouse});

  static Future<void> show(BuildContext context, {Warehouse? warehouse}) {
    return showDialog<void>(
      context: context,
      builder: (_) => WarehouseFormDialog(warehouse: warehouse),
    );
  }

  @override
  ConsumerState<WarehouseFormDialog> createState() => _WarehouseFormDialogState();
}

class _WarehouseFormDialogState extends ConsumerState<WarehouseFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _contactCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;

  bool get _isEdit => widget.warehouse != null;

  @override
  void initState() {
    super.initState();
    final w = widget.warehouse;
    _nameCtrl = TextEditingController(text: w?.name ?? '');
    _contactCtrl = TextEditingController(text: w?.contact ?? '');
    _phoneCtrl = TextEditingController(text: w?.phone ?? '');
    _addressCtrl = TextEditingController(text: w?.address ?? '');
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
      title: Text(_isEdit ? '编辑仓库' : '新增仓库'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: '仓库名称', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _contactCtrl, decoration: const InputDecoration(labelText: '联系人', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: '电话', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _addressCtrl, decoration: const InputDecoration(labelText: '地址', border: OutlineInputBorder())),
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
    final notifier = ref.read(warehouseListProvider.notifier);
    final w = Warehouse(
      id: _isEdit ? widget.warehouse!.id : notifier.generateId(),
      name: _nameCtrl.text, contact: _contactCtrl.text, phone: _phoneCtrl.text,
      address: _addressCtrl.text,
    );
    if (_isEdit) { notifier.update(w); } else { notifier.add(w); }
    Navigator.pop(context);
  }
}
