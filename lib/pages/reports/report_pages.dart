import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../providers/basic_data_provider.dart';

class SalesReportPage extends StatelessWidget {
  const SalesReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('销售报表', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              const SizedBox(height: 4),
              Text('查看销售数据分析与统计', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 16),
          _DateFilterBar(),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryCard('本月销售额', '¥128,450', Icons.trending_up, Colors.green, '+15.3%'),
              const SizedBox(width: 16),
              _buildSummaryCard('本月订单数', '46 笔', Icons.receipt, Colors.blue, '日均 1.5 笔'),
              const SizedBox(width: 16),
              _buildSummaryCard('客单价', '¥2,792', Icons.attach_money, Colors.purple, '环比 +5.2%'),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('热销商品 Top 5', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  ...List.generate(5, (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text('${i + 1}', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: i < 3 ? Colors.blue : Colors.grey[500],
                            fontSize: 16,
                          )),
                        ),
                        SizedBox(
                          width: 120,
                          child: Text(_topProducts[i].name, style: const TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (5 - i) / 5,
                              backgroundColor: Colors.grey[200],
                              color: i < 3 ? Colors.blue : Colors.grey,
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text('${_topProducts[i].sales} 件', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(width: 16),
                        Text('¥${_topProducts[i].amount}', style: const TextStyle(fontWeight: FontWeight.w600)),
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

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
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
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopProduct {
  final String name;
  final int sales;
  final String amount;
  _TopProduct(this.name, this.sales, this.amount);
}

final List<_TopProduct> _topProducts = [
  _TopProduct('笔记本电脑', 28, '195,972'),
  _TopProduct('无线鼠标', 65, '12,935'),
  _TopProduct('A4打印纸', 120, '3,360'),
  _TopProduct('显示器', 18, '39,582'),
  _TopProduct('办公椅', 22, '12,760'),
];

class PurchaseReportPage extends StatelessWidget {
  const PurchaseReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('采购报表', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              const SizedBox(height: 4),
              Text('查看采购数据分析与统计', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 16),
          _DateFilterBar(),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildCard('本月采购额', '¥87,200', Icons.shopping_cart, Colors.blue, '环比 +8.7%'),
              const SizedBox(width: 16),
              _buildCard('本月采购单数', '12 笔', Icons.receipt_long, Colors.orange, '环比 +2 笔'),
              const SizedBox(width: 16),
              _buildCard('供应商总数', '6 家', Icons.business, Colors.teal, '本月新增 1 家'),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('采购统计', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  _dataRow('采购订单总数', '156 笔'),
                  _dataRow('已完成订单', '142 笔'),
                  _dataRow('本月采购金额', '¥87,200'),
                  _dataRow('年度累计采购', '¥523,600'),
                  const Divider(height: 24),
                  const Text('供应商排名', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _supplierRow('1', '深圳华强电子有限公司', '¥286,000'),
                  _supplierRow('2', '广州办公用品批发', '¥95,400'),
                  _supplierRow('3', '顺德家具厂', '¥78,200'),
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
          color: Colors.white,
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
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
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
          Text(label, style: TextStyle(color: Colors.grey[600])),
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
          SizedBox(width: 24, child: Text(rank, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
          Expanded(child: Text(name)),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('库存报表', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              const SizedBox(height: 4),
              Text('查看库存数据分析与统计', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 16),
          _DateFilterBar(),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildCard('商品种类', '${products.length} 种', Icons.category, Colors.blue),
              const SizedBox(width: 16),
              _buildCard('库存总量', '$totalStock 件', Icons.inventory, Colors.green),
              const SizedBox(width: 16),
              _buildCard('库存总额', '¥${totalValue.toStringAsFixed(0)}', Icons.account_balance, Colors.purple),
              const SizedBox(width: 16),
              _buildCard('低库存预警', '$lowStockCount 种', Icons.warning, Colors.red),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
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
                              backgroundColor: Colors.grey[200],
                              color: c.color,
                              minHeight: 8,
                            ),
                          ),
                        ),
                        SizedBox(width: 80, child: Text('${c.count} 件', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey[600]))),
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
          color: Colors.white,
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
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
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
  final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.red, Colors.cyan, Colors.pink];
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 1))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.date_range, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 8),
          Text('2025-05-01', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('至', style: TextStyle(fontSize: 13, color: Colors.grey)),
          ),
          Text('2025-05-14', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          const SizedBox(width: 12),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                textStyle: const TextStyle(fontSize: 12),
                backgroundColor: Colors.blue,
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
