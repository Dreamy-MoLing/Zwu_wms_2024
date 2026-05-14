import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/basic_data_provider.dart';
import '../../widgets/data_table_widget.dart';

class StockTransaction {
  final String id;
  final String productName;
  final String type; // 入库 / 出库
  final int quantity;
  final DateTime date;
  final String handler;
  final String remark;

  StockTransaction({
    required this.id,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.date,
    required this.handler,
    this.remark = '',
  });
}

final List<StockTransaction> mockTransactions = [
  StockTransaction(id: 'T001', productName: '笔记本电脑', type: '入库', quantity: 10, date: DateTime(2025, 5, 12), handler: '王五', remark: '采购入库 PO2025001'),
  StockTransaction(id: 'T002', productName: '无线鼠标', type: '入库', quantity: 50, date: DateTime(2025, 5, 12), handler: '王五', remark: '采购入库 PO2025001'),
  StockTransaction(id: 'T003', productName: '笔记本电脑', type: '出库', quantity: 5, date: DateTime(2025, 5, 11), handler: '赵六', remark: '销售出库 SO2025001'),
  StockTransaction(id: 'T004', productName: '显示器', type: '出库', quantity: 5, date: DateTime(2025, 5, 11), handler: '赵六', remark: '销售出库 SO2025001'),
  StockTransaction(id: 'T005', productName: 'A4打印纸', type: '出库', quantity: 200, date: DateTime(2025, 5, 10), handler: '赵六', remark: '销售出库 SO2025004'),
  StockTransaction(id: 'T006', productName: '矿泉水', type: '入库', quantity: 50, date: DateTime(2025, 5, 9), handler: '王五', remark: '采购入库 PO2025004'),
];

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
                Text('实时查看各商品库存情况与变动记录', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 3,
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
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('近期出入库记录', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text('共 ${mockTransactions.length} 条', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: mockTransactions.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final t = mockTransactions[i];
                          final isIn = t.type == '入库';
                          return ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: (isIn ? Colors.green : Colors.blue).withValues(alpha: 0.1),
                              child: Icon(isIn ? Icons.download : Icons.upload, color: isIn ? Colors.green : Colors.blue, size: 16),
                            ),
                            title: Text('${t.productName} ${t.type}${t.quantity} ${t.remark}',
                              style: const TextStyle(fontSize: 13)),
                            subtitle: Text('${t.handler} · ${DateFormat('MM-dd HH:mm').format(t.date)}',
                              style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
