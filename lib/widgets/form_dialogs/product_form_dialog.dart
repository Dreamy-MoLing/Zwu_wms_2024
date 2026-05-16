import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../providers/basic_data_provider.dart';

class ProductFormDialog extends ConsumerStatefulWidget {
  final Product? product;

  const ProductFormDialog({super.key, this.product});

  static Future<void> show(BuildContext context, {Product? product}) {
    return showDialog<void>(
      context: context,
      builder: (_) => ProductFormDialog(product: product),
    );
  }

  @override
  ConsumerState<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends ConsumerState<ProductFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _specCtrl;
  late final TextEditingController _unitCtrl;
  late final TextEditingController _purchaseCtrl;
  late final TextEditingController _saleCtrl;
  late final TextEditingController _stockCtrl;
  late String _selectedCategory;
  late String _selectedSupplier;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _skuCtrl = TextEditingController(text: p?.sku ?? '');
    _specCtrl = TextEditingController(text: p?.spec ?? '');
    _unitCtrl = TextEditingController(text: p?.unit ?? '');
    _purchaseCtrl = TextEditingController(text: p?.purchasePrice.toString() ?? '');
    _saleCtrl = TextEditingController(text: p?.salePrice.toString() ?? '');
    _stockCtrl = TextEditingController(text: p?.stock.toString() ?? '0');

    final suppliers = ref.read(supplierListProvider);
    _selectedCategory = p?.category ?? categoryOptions[0];
    _selectedSupplier = p?.supplierName.isNotEmpty == true
        ? p!.supplierName
        : (suppliers.isNotEmpty ? suppliers.first.name : '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _specCtrl.dispose();
    _unitCtrl.dispose();
    _purchaseCtrl.dispose();
    _saleCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = ref.watch(supplierListProvider);
    return AlertDialog(
      title: Text(_isEdit ? '编辑商品' : '新增商品'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: '商品名称', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _skuCtrl, decoration: const InputDecoration(labelText: 'SKU', border: OutlineInputBorder(), hintText: '商品编码，如 NB-ThinkPad-X1')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(labelText: '分类', border: OutlineInputBorder()),
              items: categoryOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 12),
            TextField(controller: _specCtrl, decoration: const InputDecoration(labelText: '规格', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _unitCtrl, decoration: const InputDecoration(labelText: '单位', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedSupplier,
              decoration: const InputDecoration(labelText: '供应商', border: OutlineInputBorder()),
              items: suppliers.where((s) => s.enabled).map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
              onChanged: (v) => setState(() => _selectedSupplier = v!),
            ),
            const SizedBox(height: 12),
            TextField(controller: _purchaseCtrl, decoration: const InputDecoration(labelText: '采购价', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _saleCtrl, decoration: const InputDecoration(labelText: '销售价', border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _stockCtrl, decoration: const InputDecoration(labelText: '库存数量', border: OutlineInputBorder()), keyboardType: TextInputType.number),
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
    final notifier = ref.read(productListProvider.notifier);
    final p = Product(
      id: _isEdit ? widget.product!.id : notifier.generateId(),
      sku: _skuCtrl.text,
      name: _nameCtrl.text,
      category: _selectedCategory,
      spec: _specCtrl.text,
      unit: _unitCtrl.text,
      purchasePrice: double.tryParse(_purchaseCtrl.text) ?? 0,
      salePrice: double.tryParse(_saleCtrl.text) ?? 0,
      stock: int.tryParse(_stockCtrl.text) ?? 0,
      supplierName: _selectedSupplier,
    );
    if (_isEdit) { notifier.update(p); } else { notifier.add(p); }
    Navigator.pop(context);
  }
}
