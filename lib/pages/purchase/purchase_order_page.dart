import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../providers/purchase_provider.dart';
import '../../providers/basic_data_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/data_table_widget.dart';
import 'package:intl/intl.dart';

class PurchaseOrderPage extends ConsumerWidget {
  const PurchaseOrderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(purchaseOrderListProvider);
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
                    DataColumn(label: Text('订单号')),
                    DataColumn(label: Text('供应商')),
                    DataColumn(label: Text('订单日期')),
                    DataColumn(label: Text('金额')),
                    DataColumn(label: Text('状态')),
                    DataColumn(label: Text('经办人')),
                    DataColumn(label: Text('操作')),
                  ],
                  rows: orders.map((o) => DataRow(cells: [
                    DataCell(Text(o.id)),
                    DataCell(Text(o.supplierName)),
                    DataCell(Text(DateFormat('yyyy-MM-dd').format(o.orderDate))),
                    DataCell(Text('¥${o.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(_buildStatusChip(o.status)),
                    DataCell(Text(o.handler)),
                    DataCell(_buildActionButtons(context, ref, o, products)),
                  ])).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, PurchaseOrder o, List<Product> products) {
    final notifier = ref.read(purchaseOrderListProvider.notifier);
    return Row(
      children: [
        if (o.status == '待审核') ...[
          TextButton(onPressed: () => notifier.updateStatus(o.id, '已通过'), child: const Text('通过', style: TextStyle(fontSize: 12, color: Colors.green))),
          TextButton(onPressed: () => notifier.updateStatus(o.id, '已取消'), child: const Text('取消', style: TextStyle(fontSize: 12, color: Colors.red))),
        ],
        if (o.status == '已通过')
          TextButton(onPressed: () => notifier.updateStatus(o.id, '已完成'), child: const Text('完成', style: TextStyle(fontSize: 12, color: Colors.blue))),
        if (o.status == '已完成') ...[
          TextButton(
            onPressed: () {
              for (final item in o.items) {
                for (var i = 0; i < products.length; i++) {
                  if (products[i].id == item.productId) {
                    final updated = products[i].copyWith(stock: products[i].stock + item.quantity);
                    ref.read(productListProvider.notifier).updateProduct(updated);
                    break;
                  }
                }
              }
              notifier.updateStatus(o.id, '已入库');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('入库完成，库存已更新')));
            },
            child: const Text('入库', style: TextStyle(fontSize: 12, color: Colors.teal)),
          ),
        ],
        TextButton(onPressed: () => _showDetail(context, o), child: const Text('详情', style: TextStyle(fontSize: 12))),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final colors = {'待审核': Colors.orange, '已通过': Colors.blue, '已完成': Colors.green, '已取消': Colors.red, '已入库': Colors.teal};
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: (colors[status] ?? Colors.grey).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(fontSize: 12, color: colors[status] ?? Colors.grey)),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('采购订单', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 4),
            Text('管理采购订单的创建与审核', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showCreateDialog(context, ref),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新建采购订单'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

  void _showDetail(BuildContext context, PurchaseOrder order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('订单详情 - ${order.id}'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('供应商', order.supplierName),
              _detailRow('订单日期', DateFormat('yyyy-MM-dd').format(order.orderDate)),
              _detailRow('状态', order.status),
              _detailRow('经办人', order.handler),
              _detailRow('总金额', '¥${order.totalAmount.toStringAsFixed(2)}'),
              const Divider(),
              const Text('商品明细:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...order.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('${item.productName} x${item.quantity} ${item.unit}  @ ¥${item.price.toStringAsFixed(0)}  = ¥${item.amount.toStringAsFixed(0)}'),
              )),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('关闭'))],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text('$label:', style: TextStyle(color: Colors.grey[600]))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final suppliers = ref.read(supplierListProvider);
    final products = ref.read(productListProvider);
    String selectedSupplier = suppliers.first.name;
    String selectedProduct = products.first.name;
    int quantity = 1;
    final priceCtrl = TextEditingController(text: products.first.purchasePrice.toString());

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('新建采购订单'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                DropdownButtonFormField<String>(
                  key: ValueKey(selectedSupplier),
                  initialValue: selectedSupplier,
                  decoration: const InputDecoration(labelText: '供应商', border: OutlineInputBorder()),
                  items: suppliers.where((s) => s.enabled).map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
                  onChanged: (v) => setState(() => selectedSupplier = v!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey(selectedProduct),
                  initialValue: selectedProduct,
                  decoration: const InputDecoration(labelText: '商品', border: OutlineInputBorder()),
                  items: products.map((p) => DropdownMenuItem(value: p.name, child: Text('${p.name} (${p.spec})'))).toList(),
                  onChanged: (v) {
                    final p = products.firstWhere((e) => e.name == v);
                    setState(() {
                      selectedProduct = v!;
                      priceCtrl.text = p.purchasePrice.toString();
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  decoration: const InputDecoration(labelText: '单价', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('数量: '),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => quantity++),
                    ),
                  ],
                ),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
            ElevatedButton(
              onPressed: () {
                final product = products.firstWhere((e) => e.name == selectedProduct);
                final price = double.tryParse(priceCtrl.text) ?? product.purchasePrice;
                final notifier = ref.read(purchaseOrderListProvider.notifier);
                notifier.add(PurchaseOrder(
                  id: notifier.generateId(),
                  supplierName: selectedSupplier,
                  orderDate: DateTime.now(),
                  handler: ref.read(currentUserProvider)?.displayName ?? '',
                  items: [OrderItem(
                    productId: product.id, productName: product.name,
                    spec: product.spec, unit: product.unit,
                    quantity: quantity, price: price,
                  )],
                ));
                Navigator.pop(ctx);
              },
              child: const Text('创建'),
            ),
          ],
        ),
      ),
    );
  }
}
