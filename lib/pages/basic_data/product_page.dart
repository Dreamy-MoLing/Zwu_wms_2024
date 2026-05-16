import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/basic_data_provider.dart';
import '../../widgets/data_table_widget.dart';
import '../../widgets/form_dialogs/product_form_dialog.dart';
import '../../theme/theme.dart';

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
                  color: AppColors.bgPrimary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
                ),
                child: DataTableWidget(
                  columns: const [
                    DataColumn(label: Text('编号')),
                    DataColumn(label: Text('SKU')),
                    DataColumn(label: Text('商品名称')),
                    DataColumn(label: Text('分类')),
                    DataColumn(label: Text('规格')),
                    DataColumn(label: Text('单位')),
                    DataColumn(label: Text('供应商')),
                    DataColumn(label: Text('采购价')),
                    DataColumn(label: Text('销售价')),
                    DataColumn(label: Text('库存')),
                    DataColumn(label: Text('操作')),
                  ],
                  rows: products.map((p) => DataRow(cells: [
                    DataCell(Text(p.id)),
                    DataCell(Text(p.sku, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary))),
                    DataCell(Text(p.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(_buildCategoryChip(p.category)),
                    DataCell(Text(p.spec)),
                    DataCell(Text(p.unit)),
                    DataCell(Text(p.supplierName, style: const TextStyle(fontSize: 12))),
                    DataCell(Text('¥${p.purchasePrice.toStringAsFixed(0)}')),
                    DataCell(Text('¥${p.salePrice.toStringAsFixed(0)}')),
                    DataCell(Text('${p.stock}', style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: p.stock < 50 ? AppColors.error : AppColors.success,
                    ))),
                    DataCell(Row(
                      children: [
                        TextButton(onPressed: () => ProductFormDialog.show(context, product: p), child: const Text('编辑', style: TextStyle(fontSize: 12))),
                        TextButton(onPressed: () => ref.read(productListProvider.notifier).delete(p.id), child: const Text('删除', style: TextStyle(fontSize: 12, color: AppColors.error))),
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
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('商品管理', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text('管理商品信息与价格', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => ProductFormDialog.show(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('新增商品'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(category, style: const TextStyle(fontSize: 12, color: AppColors.info)),
    );
  }

}
