import 'package:flutter/material.dart';
import '../../widgets/stat_card.dart';

class DashboardPage extends StatelessWidget {
  final ValueChanged<String>? onNavigate;
  const DashboardPage({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '欢迎使用企业进销存管理系统',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '在这里可以查看企业的运营概况',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          // 统计卡片
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 220,
                child: StatCard(
                  title: '今日销售额',
                  value: '¥ 45,890',
                  icon: Icons.trending_up,
                  color: Colors.green,
                  subtitle: '较昨日 +12.5%',
                  onTap: () => onNavigate?.call('/reports/sales'),
                ),
              ),
              SizedBox(
                width: 220,
                child: StatCard(
                  title: '采购订单数',
                  value: '156',
                  icon: Icons.shopping_cart,
                  color: Colors.blue,
                  subtitle: '本月新增 23 笔',
                  onTap: () => onNavigate?.call('/purchase/orders'),
                ),
              ),
              SizedBox(
                width: 220,
                child: StatCard(
                  title: '库存商品数',
                  value: '1,280',
                  icon: Icons.inventory,
                  color: Colors.orange,
                  subtitle: '低库存预警 8 种',
                  onTap: () => onNavigate?.call('/inventory/stock'),
                ),
              ),
              SizedBox(
                width: 220,
                child: StatCard(
                  title: '客户总数',
                  value: '86',
                  icon: Icons.people,
                  color: Colors.purple,
                  subtitle: '本月新增 5 家',
                  onTap: () => onNavigate?.call('/basic/customers'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildCard(
                    title: '最近交易动态',
                    child: ListView.separated(
                      itemCount: _recentActivities.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final a = _recentActivities[i];
                        return ListTile(
                          dense: true,
                          leading: Icon(a.icon, color: a.color, size: 20),
                          title: Text(
                            a.text,
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: Text(
                            a.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildCard(
                    title: '待处理事项',
                    child: ListView.separated(
                      itemCount: _pendingItems.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final p = _pendingItems[i];
                        return ListTile(
                          dense: true,
                          leading: Icon(p.icon, color: p.color, size: 20),
                          title: Text(
                            p.text,
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: Text(
                            '${p.count}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Activity {
  final String text, time;
  final IconData icon;
  final Color color;
  _Activity({
    required this.text,
    required this.time,
    required this.icon,
    required this.color,
  });
}

final List<_Activity> _recentActivities = [
  _Activity(
    text: '采购订单 PO2025003 已通过审核',
    time: '10分钟前',
    icon: Icons.check_circle,
    color: Colors.green,
  ),
  _Activity(
    text: '销售订单 SO2025005 已创建',
    time: '30分钟前',
    icon: Icons.add_circle,
    color: Colors.blue,
  ),
  _Activity(
    text: '商品 "笔记本电脑" 库存不足预警',
    time: '1小时前',
    icon: Icons.warning,
    color: Colors.orange,
  ),
  _Activity(
    text: '供应商 "深圳华强电子" 资料已更新',
    time: '2小时前',
    icon: Icons.edit,
    color: Colors.blueGrey,
  ),
  _Activity(
    text: '库存盘点完成 - 办公用品品类',
    time: '3小时前',
    icon: Icons.assignment_turned_in,
    color: Colors.teal,
  ),
  _Activity(
    text: '新客户 "武汉采购中心" 注册成功',
    time: '5小时前',
    icon: Icons.person_add,
    color: Colors.purple,
  ),
];

class _PendingItem {
  final String text;
  final IconData icon;
  final Color color;
  final int count;
  _PendingItem({
    required this.text,
    required this.icon,
    required this.color,
    required this.count,
  });
}

final List<_PendingItem> _pendingItems = [
  _PendingItem(
    text: '待审核采购订单',
    icon: Icons.receipt_long,
    color: Colors.orange,
    count: 3,
  ),
  _PendingItem(
    text: '待审核销售订单',
    icon: Icons.receipt,
    color: Colors.orange,
    count: 2,
  ),
  _PendingItem(
    text: '待处理退货申请',
    icon: Icons.replay,
    color: Colors.red,
    count: 1,
  ),
  _PendingItem(
    text: '待盘点库存',
    icon: Icons.assignment,
    color: Colors.blue,
    count: 5,
  ),
  _PendingItem(
    text: '低库存商品预警',
    icon: Icons.inventory,
    color: Colors.red,
    count: 8,
  ),
];
