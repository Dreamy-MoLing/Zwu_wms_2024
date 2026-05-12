import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/basic_data_provider.dart';
import '../../widgets/data_table_widget.dart';

class StockPage extends ConsumerWidget {
  const StockPage({super.key});

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('库存查询', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                const SizedBox(height: 4),
                Text('实时查看各商品库存情况', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              ],
            ),
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
                    DataColumn(label: Text('库存数量')),
                    DataColumn(label: Text('采购价')),
                    DataColumn(label: Text('库存总额')),
                    DataColumn(label: Text('状态')),
                  ],
                  rows: products.map((p) {
                    final totalValue = p.stock * p.purchasePrice;
                    final isLow = p.stock < 50;
                    return DataRow(cells: [
                      DataCell(Text(p.id)),
                      DataCell(Text(p.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                      DataCell(Text(p.category)),
                      DataCell(Text(p.spec)),
                      DataCell(Text(p.unit)),
                      DataCell(Text('${p.stock}', style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isLow ? Colors.red : (p.stock > 200 ? Colors.green : Colors.black87),
                      ))),
                      DataCell(Text('¥${p.purchasePrice.toStringAsFixed(0)}')),
                      DataCell(Text('¥${totalValue.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600))),
                      DataCell(isLow
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                              child: const Text('低库存', style: TextStyle(fontSize: 12, color: Colors.red)),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                              child: const Text('正常', style: TextStyle(fontSize: 12, color: Colors.green)),
                            )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
