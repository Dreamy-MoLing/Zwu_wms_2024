import 'package:flutter/material.dart';

class SalesReturnPage extends StatelessWidget {
  const SalesReturnPage({super.key});

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
              Text('销售退货', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              const SizedBox(height: 4),
              Text('管理销售退货流程', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
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
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      child: const Icon(Icons.replay_circle_filled, color: Colors.red),
                    ),
                    title: Text(r.id, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${r.customer} · ${r.reason} · ${r.date}'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (r.status == '已完成' ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(r.status, style: TextStyle(fontSize: 12, color: r.status == '已完成' ? Colors.green : Colors.orange)),
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
  _SalesReturn('SR2025001', '上海贸易商行', '客户退货', '2025-05-11', '待处理'),
  _SalesReturn('SR2025002', '北京科技公司', '商品损坏', '2025-05-09', '已完成'),
  _SalesReturn('SR2025003', '广州零售店', '尺码不符', '2025-05-07', '已完成'),
];

class _SalesReturn {
  final String id, customer, reason, date, status;
  _SalesReturn(this.id, this.customer, this.reason, this.date, this.status);
}
