import 'package:flutter/material.dart';

class StockCheckPage extends StatelessWidget {
  const StockCheckPage({super.key});

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
              Text('库存盘点', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              const SizedBox(height: 4),
              Text('管理库存盘点任务与记录', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
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
                itemCount: _records.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (_, i) {
                  final r = _records[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _statusColor(r.status).withValues(alpha: 0.1),
                      child: Icon(_statusIcon(r.status), color: _statusColor(r.status)),
                    ),
                    title: Text(r.id, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${r.category} · 盘点人: ${r.handler} · ${r.date}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _statusColor(r.status).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(r.status, style: TextStyle(fontSize: 12, color: _statusColor(r.status))),
                        ),
                        if (r.status == '进行中') ...[
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => _showCheckDialog(context, r),
                            child: const Text('完成盘点', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ],
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

  Color _statusColor(String status) {
    switch (status) {
      case '待盘点': return Colors.orange;
      case '进行中': return Colors.blue;
      case '已完成': return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case '待盘点': return Icons.pending;
      case '进行中': return Icons.autorenew;
      case '已完成': return Icons.check_circle;
      default: return Icons.help;
    }
  }

  void _showCheckDialog(BuildContext context, _Record r) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('完成盘点'),
        content: const Text('确认完成该盘点任务?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('盘点已完成')),
              );
              Navigator.pop(ctx);
            },
            child: const Text('确认完成'),
          ),
        ],
      ),
    );
  }
}

class _Record {
  final String id, category, handler, date, status;
  _Record(this.id, this.category, this.handler, this.date, this.status);
}

final List<_Record> _records = [
  _Record('CHK2025001', '电子产品', '王五', '2025-05-12', '进行中'),
  _Record('CHK2025002', '办公用品', '王五', '2025-05-10', '已完成'),
  _Record('CHK2025003', '家具', '王五', '2025-05-08', '已完成'),
  _Record('CHK2025004', '食品饮料', '', '2025-05-15', '待盘点'),
  _Record('CHK2025005', '服装鞋帽', '', '2025-05-16', '待盘点'),
];
