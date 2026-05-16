import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../providers/basic_data_provider.dart';
import '../../providers/purchase_provider.dart';
import '../../theme/theme.dart';

class SalesReportPage extends ConsumerWidget {
  const SalesReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(salesOrderListProvider);
    final completedOrders = orders.where((o) => o.status == '已完成').toList();

    final monthlySales = completedOrders.fold(0.0, (s, o) => s + o.totalAmount);
    final orderCount = completedOrders.length;
    final avgOrderValue = orderCount > 0 ? monthlySales / orderCount : 0;

    final productQty = <String, int>{};
    final productAmt = <String, double>{};
    for (final o in completedOrders) {
      for (final item in o.items) {
        productQty[item.productName] = (productQty[item.productName] ?? 0) + item.quantity;
        productAmt[item.productName] = (productAmt[item.productName] ?? 0) + item.amount;
      }
    }
    final top5 = productQty.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxQty = top5.isNotEmpty ? top5.first.value : 1;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('销售报表', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              SizedBox(height: 4),
              Text('查看销售数据分析与统计', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
            ],
          ),
          const SizedBox(height: 16),
          const _DateFilterBar(),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryCard('累计销售额', '¥${_formatAmount(monthlySales)}', Icons.trending_up, AppColors.success, '${completedOrders.length} 笔已完成'),
              const SizedBox(width: 16),
              _buildSummaryCard('订单总数', '${orders.length} 笔', Icons.receipt, AppColors.info, '已完成 ${completedOrders.length} 笔'),
              const SizedBox(width: 16),
              _buildSummaryCard('客单价', '¥${avgOrderValue.toStringAsFixed(0)}', Icons.attach_money, Colors.purple, '${completedOrders.length} 单'),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('热销商品 Top 5', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  ...top5.take(5).toList().asMap().entries.map((e) {
                    final i = e.key;
                    final entry = e.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            child: Text('${i + 1}', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: i < 3 ? AppColors.info : AppColors.textTertiary,
                              fontSize: 16,
                            )),
                          ),
                          SizedBox(
                            width: 120,
                            child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: maxQty > 0 ? entry.value / maxQty : 0,
                                backgroundColor: AppColors.bgQuaternary,
                                color: i < 3 ? AppColors.info : AppColors.textTertiary,
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('${entry.value} 件', style: const TextStyle(color: AppColors.textSecondary)),
                          const SizedBox(width: 16),
                          Text('¥${_formatAmount(productAmt[entry.key] ?? 0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: AppColors.textDisabled, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PurchaseReportPage extends ConsumerWidget {
  const PurchaseReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(purchaseOrderListProvider);
    final suppliers = ref.watch(supplierListProvider);

    final totalOrders = orders.length;
    final completedOrders = orders.where((o) => o.status == '已完成' || o.status == '已入库').length;
    final totalPurchase = orders.fold(0.0, (s, o) => s + o.totalAmount);

    final supplierAmount = <String, double>{};
    for (final o in orders) {
      supplierAmount[o.supplierName] = (supplierAmount[o.supplierName] ?? 0) + o.totalAmount;
    }
    final topSuppliers = supplierAmount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('采购报表', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              SizedBox(height: 4),
              Text('查看采购数据分析与统计', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
            ],
          ),
          const SizedBox(height: 16),
          const _DateFilterBar(),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildCard('累计采购额', '¥${_formatAmount(totalPurchase)}', Icons.shopping_cart, AppColors.info, '${orders.length} 笔订单'),
              const SizedBox(width: 16),
              _buildCard('订单总数', '$totalOrders 笔', Icons.receipt_long, AppColors.warning, '已完成 $completedOrders 笔'),
              const SizedBox(width: 16),
              _buildCard('供应商总数', '${suppliers.length} 家', Icons.business, AppColors.completed, '本月新增 1 家'),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('采购统计', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  _dataRow('采购订单总数', '$totalOrders 笔'),
                  _dataRow('已完成订单', '$completedOrders 笔'),
                  _dataRow('累计采购金额', '¥${_formatAmount(totalPurchase)}'),
                  _dataRow('供应商数量', '${suppliers.length} 家'),
                  const Divider(height: 24),
                  const Text('供应商排名', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  ...topSuppliers.take(5).toList().asMap().entries.map((e) =>
                    _supplierRow('${e.key + 1}', e.value.key, '¥${_formatAmount(e.value.value)}')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: AppColors.textDisabled, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _supplierRow(String rank, String name, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 24, child: Text(rank, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.info))),
          Expanded(child: Text(name)),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

String _formatAmount(double amount) {
  if (amount >= 10000) {
    return '${(amount / 10000).toStringAsFixed(1)}万';
  }
  return amount.toStringAsFixed(0);
}

class InventoryReportPage extends ConsumerWidget {
  const InventoryReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);
    final totalStock = products.fold(0, (sum, p) => sum + p.stock);
    final totalValue = products.fold(0.0, (sum, p) => sum + p.stock * p.purchasePrice);
    final lowStockCount = products.where((p) => p.stock < 50).length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('库存报表', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              SizedBox(height: 4),
              Text('查看库存数据分析与统计', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
            ],
          ),
          const SizedBox(height: 16),
          const _DateFilterBar(),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildCard('商品种类', '${products.length} 种', Icons.category, AppColors.info),
              const SizedBox(width: 16),
              _buildCard('库存总量', '$totalStock 件', Icons.inventory, AppColors.success),
              const SizedBox(width: 16),
              _buildCard('库存总额', '¥${totalValue.toStringAsFixed(0)}', Icons.account_balance, Colors.purple),
              const SizedBox(width: 16),
              _buildCard('低库存预警', '$lowStockCount 种', Icons.warning, AppColors.error),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('分类库存分布', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  ..._getCategorySummary(products).map((c) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        SizedBox(width: 100, child: Text(c.category, style: const TextStyle(fontWeight: FontWeight.w500))),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: c.ratio,
                              backgroundColor: AppColors.bgQuaternary,
                              color: c.color,
                              minHeight: 8,
                            ),
                          ),
                        ),
                        SizedBox(width: 80, child: Text('${c.count} 件', textAlign: TextAlign.right, style: const TextStyle(color: AppColors.textSecondary))),
                        SizedBox(width: 80, child: Text('¥${c.value}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySummary {
  final String category;
  final int count;
  final String value;
  final double ratio;
  final Color color;
  _CategorySummary(this.category, this.count, this.value, this.ratio, this.color);
}

List<_CategorySummary> _getCategorySummary(List<Product> products) {
  final categories = <String, int>{};
  final values = <String, double>{};
  final colors = [AppColors.info, AppColors.success, AppColors.warning, Colors.purple, AppColors.completed, AppColors.error, Colors.cyan, Colors.pink];
  int maxCount = 0;

  for (final p in products) {
    categories[p.category] = (categories[p.category] ?? 0) + p.stock;
    values[p.category] = (values[p.category] ?? 0) + p.stock * p.purchasePrice;
    maxCount = maxCount > categories[p.category]! ? maxCount : categories[p.category]!;
  }

  final entries = categories.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  return entries.asMap().entries.map((e) {
    final idx = e.key;
    final entry = e.value;
    return _CategorySummary(
      entry.key,
      entry.value,
      (values[entry.key] ?? 0).toStringAsFixed(0),
      maxCount > 0 ? entry.value / maxCount : 0.0,
      colors[idx % colors.length],
    );
  }).toList();
}

class _DateFilterBar extends StatelessWidget {
  const _DateFilterBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 1))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.date_range, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 8),
          const Text('2025-05-01', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('至', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          ),
          const Text('2025-05-14', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(width: 12),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                textStyle: const TextStyle(fontSize: 12),
                backgroundColor: AppColors.info,
                foregroundColor: Colors.white,
              ),
              child: const Text('查询'),
            ),
          ),
        ],
      ),
    );
  }
}
