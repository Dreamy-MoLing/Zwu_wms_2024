import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../providers/purchase_provider.dart';
import '../../providers/basic_data_provider.dart';
import '../../widgets/data_table_widget.dart';
import '../../widgets/form_dialogs/purchase_order_form_dialog.dart';
import '../../theme/theme.dart';
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
                  color: AppColors.bgPrimary,
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
          TextButton(onPressed: () => notifier.updateStatus(o.id, (p) => p.copyWith(status: '已通过')), child: const Text('通过', style: TextStyle(fontSize: 12, color: AppColors.success))),
          TextButton(onPressed: () => notifier.updateStatus(o.id, (p) => p.copyWith(status: '已取消')), child: const Text('取消', style: TextStyle(fontSize: 12, color: AppColors.error))),
        ],
        if (o.status == '已通过')
          TextButton(onPressed: () => notifier.updateStatus(o.id, (p) => p.copyWith(status: '已完成')), child: const Text('完成', style: TextStyle(fontSize: 12, color: AppColors.info))),
        if (o.status == '已完成') ...[
          TextButton(
            onPressed: () {
              for (final item in o.items) {
                for (var i = 0; i < products.length; i++) {
                  if (products[i].id == item.productId) {
                    final updated = products[i].copyWith(stock: products[i].stock + item.quantity);
                    ref.read(productListProvider.notifier).update(updated);
                    break;
                  }
                }
              }
              notifier.updateStatus(o.id, (p) => p.copyWith(status: '已入库'));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('入库完成，库存已更新')));
            },
            child: const Text('入库', style: TextStyle(fontSize: 12, color: AppColors.completed)),
          ),
        ],
        TextButton(onPressed: () => _showDetail(context, o), child: const Text('详情', style: TextStyle(fontSize: 12))),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final colors = {'待审核': AppColors.warning, '已通过': AppColors.info, '已完成': AppColors.success, '已取消': AppColors.error, '已入库': AppColors.completed};
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
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('采购订单', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text('管理采购订单的创建与审核', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => PurchaseOrderFormDialog.show(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新建采购订单'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
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
          SizedBox(width: 80, child: Text('$label:', style: const TextStyle(color: AppColors.textSecondary))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

}
