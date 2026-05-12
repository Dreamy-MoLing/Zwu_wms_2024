import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../providers/basic_data_provider.dart';
import '../../widgets/data_table_widget.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);
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
                    DataColumn(label: Text('商品名称')),
                    DataColumn(label: Text('分类')),
                    DataColumn(label: Text('规格')),
                    DataColumn(label: Text('单位')),
                    DataColumn(label: Text('采购价')),
                    DataColumn(label: Text('销售价')),
                    DataColumn(label: Text('库存')),
                    DataColumn(label: Text('操作')),
                  ],
                  rows: products.map((p) => DataRow(cells: [
                    DataCell(Text(p.id)),
                    DataCell(Text(p.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(_buildCategoryChip(p.category)),
                    DataCell(Text(p.spec)),
                    DataCell(Text(p.unit)),
                    DataCell(Text('¥${p.purchasePrice.toStringAsFixed(0)}')),
                    DataCell(Text('¥${p.salePrice.toStringAsFixed(0)}')),
                    DataCell(Text('${p.stock}', style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: p.stock < 50 ? Colors.red : Colors.green,
                    ))),
                    DataCell(Row(
                      children: [
                        TextButton(onPressed: () => _showProductDialog(context, ref, p), child: const Text('编辑', style: TextStyle(fontSize: 12))),
                        TextButton(onPressed: () => ref.read(productListProvider.notifier).deleteProduct(p.id), child: const Text('删除', style: TextStyle(fontSize: 12, color: Colors.red))),
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

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('商品管理', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 4),
            Text('管理商品信息与价格', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showProductDialog(context, ref, null),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新增商品'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(category, style: const TextStyle(fontSize: 12, color: Colors.blue)),
    );
  }

  void _showProductDialog(BuildContext context, WidgetRef ref, Product? product) {
    final isEdit = product != null;
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final specCtrl = TextEditingController(text: product?.spec ?? '');
    final unitCtrl = TextEditingController(text: product?.unit ?? '');
    final purchaseCtrl = TextEditingController(text: product?.purchasePrice.toString() ?? '');
    final saleCtrl = TextEditingController(text: product?.salePrice.toString() ?? '');
    final stockCtrl = TextEditingController(text: product?.stock.toString() ?? '0');
    String selectedCategory = product?.category ?? categoryOptions[0];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(isEdit ? '编辑商品' : '新增商品'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '商品名称', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey(selectedCategory),
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(labelText: '分类', border: OutlineInputBorder()),
                  items: categoryOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => selectedCategory = v!),
                ),
                const SizedBox(height: 12),
                TextField(controller: specCtrl, decoration: const InputDecoration(labelText: '规格', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: unitCtrl, decoration: const InputDecoration(labelText: '单位', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: purchaseCtrl, decoration: const InputDecoration(labelText: '采购价', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                TextField(controller: saleCtrl, decoration: const InputDecoration(labelText: '销售价', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                TextField(controller: stockCtrl, decoration: const InputDecoration(labelText: '库存数量', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
            ElevatedButton(
              onPressed: () {
                final notifier = ref.read(productListProvider.notifier);
                final p = Product(
                  id: isEdit ? product.id : notifier.generateId(),
                  name: nameCtrl.text,
                  category: selectedCategory,
                  spec: specCtrl.text,
                  unit: unitCtrl.text,
                  purchasePrice: double.tryParse(purchaseCtrl.text) ?? 0,
                  salePrice: double.tryParse(saleCtrl.text) ?? 0,
                  stock: int.tryParse(stockCtrl.text) ?? 0,
                );
                if (isEdit) { notifier.updateProduct(p); } else { notifier.addProduct(p); }
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
