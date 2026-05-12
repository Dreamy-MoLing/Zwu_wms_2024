import 'package:flutter/material.dart';

class PurchaseReturnPage extends StatelessWidget {
  const PurchaseReturnPage({super.key});

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
              Text('采购退货', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              const SizedBox(height: 4),
              Text('管理采购退货流程', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
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
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _returns.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (_, i) {
                  final r = _returns[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.withValues(alpha: 0.1),
                      child: const Icon(Icons.replay, color: Colors.orange),
                    ),
                    title: Text(r.id, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${r.supplier} · ${r.reason} · ${r.date}'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(r.status, style: const TextStyle(fontSize: 12, color: Colors.orange)),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final _returns = [
  _Return('PR2025001', '深圳华强电子有限公司', '商品质量问题', '2025-05-10', '待处理'),
  _Return('PR2025002', '广州办公用品批发', '数量不符', '2025-05-08', '已完成'),
];

class _Return {
  final String id, supplier, reason, date, status;
  _Return(this.id, this.supplier, this.reason, this.date, this.status);
}
