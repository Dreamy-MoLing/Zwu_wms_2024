import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../providers/purchase_provider.dart';
import '../../providers/basic_data_provider.dart';
import '../../providers/auth_provider.dart';

class PurchaseOrderFormDialog extends ConsumerStatefulWidget {
  const PurchaseOrderFormDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const PurchaseOrderFormDialog(),
    );
  }

  @override
  ConsumerState<PurchaseOrderFormDialog> createState() => _PurchaseOrderFormDialogState();
}

class _PurchaseOrderFormDialogState extends ConsumerState<PurchaseOrderFormDialog> {
  late String _selectedSupplier;
  late String _selectedProduct;
  late int _quantity;
  late final TextEditingController _priceCtrl;

  @override
  void initState() {
    super.initState();
    final products = ref.read(productListProvider);
    final suppliers = ref.read(supplierListProvider);
    _selectedSupplier = suppliers.first.name;
    _selectedProduct = products.first.name;
    _quantity = 1;
    _priceCtrl = TextEditingController(text: products.first.purchasePrice.toString());
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = ref.watch(supplierListProvider);
    final products = ref.watch(productListProvider);
    return AlertDialog(
      title: const Text('新建采购订单'),
      content: SizedBox(
        width: 450,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedSupplier,
              decoration: const InputDecoration(labelText: '供应商', border: OutlineInputBorder()),
              items: suppliers.where((s) => s.enabled).map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
              onChanged: (v) => setState(() => _selectedSupplier = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedProduct,
              decoration: const InputDecoration(labelText: '商品', border: OutlineInputBorder()),
              items: products.map((p) => DropdownMenuItem(value: p.name, child: Text('${p.name} (${p.spec})'))).toList(),
              onChanged: (v) {
                final p = products.firstWhere((e) => e.name == v);
                setState(() {
                  _selectedProduct = v!;
                  _priceCtrl.text = p.purchasePrice.toString();
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceCtrl,
              decoration: const InputDecoration(labelText: '单价', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('数量: '),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                ),
                Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
        ElevatedButton(onPressed: () => _submit(products), child: const Text('创建')),
      ],
    );
  }

  void _submit(List<Product> products) {
    final product = products.firstWhere((e) => e.name == _selectedProduct);
    final price = double.tryParse(_priceCtrl.text) ?? product.purchasePrice;
    final notifier = ref.read(purchaseOrderListProvider.notifier);
    notifier.add(PurchaseOrder(
      id: notifier.generateId(),
      supplierName: _selectedSupplier,
      orderDate: DateTime.now(),
      handler: ref.read(currentUserProvider)?.displayName ?? '',
      items: [OrderItem(
        productId: product.id, productName: product.name,
        spec: product.spec, unit: product.unit,
        quantity: _quantity, price: price,
      )],
    ));
    Navigator.pop(context);
  }
}
