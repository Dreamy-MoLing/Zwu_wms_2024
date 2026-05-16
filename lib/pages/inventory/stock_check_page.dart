import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/stock_provider.dart';
import '../../theme/theme.dart';

class StockCheckPage extends ConsumerWidget {
  const StockCheckPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(stockCheckListProvider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('库存盘点', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              SizedBox(height: 4),
              Text('管理库存盘点任务与记录', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bgPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: records.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (_, i) {
                  final r = records[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _statusColor(r.status).withValues(alpha: 0.1),
                      child: Icon(_statusIcon(r.status), color: _statusColor(r.status)),
                    ),
                    title: Text(r.id, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${r.category} · 盘点人: ${r.handler} · ${r.date.toString().substring(0, 10)}'),
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
                            onPressed: () => _showCheckDialog(context, ref, r.id),
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
      case '待盘点': return AppColors.warning;
      case '进行中': return AppColors.info;
      case '已完成': return AppColors.success;
      default: return AppColors.textTertiary;
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

  void _showCheckDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('完成盘点'),
        content: const Text('确认完成该盘点任务?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              ref.read(stockCheckListProvider.notifier).completeCheck(id);
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
