import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'sidebar.dart';

class AppLayout extends ConsumerStatefulWidget {
  final Widget child;
  final String title;
  final String currentRoute;
  final ValueChanged<String> onRouteChanged;

  const AppLayout({
    super.key,
    required this.child,
    required this.title,
    required this.currentRoute,
    required this.onRouteChanged,
  });

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.notifications, size: 22),
            SizedBox(width: 8),
            Text('通知'),
          ],
        ),
        content: SizedBox(
          width: 360,
          child: ListView(
            shrinkWrap: true,
            children: [
              _notificationItem('采购订单 PO-2024-001 已入库', '5 分钟前', Icons.shopping_cart),
              const Divider(height: 1),
              _notificationItem('销售单 SO-2024-008 已出库', '30 分钟前', Icons.point_of_sale),
              const Divider(height: 1),
              _notificationItem('商品"无线鼠标"库存不足（当前库存：2）', '2 小时前', Icons.inventory),
              const Divider(height: 1),
              _notificationItem('库存盘点完成，差异已记录', '昨天', Icons.assignment),
              const Divider(height: 1),
              _notificationItem('新客户"深圳科技有限公司"已注册', '昨天', Icons.person_add),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _notificationItem(String text, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          // Web 端总是显示侧边栏
          if (MediaQuery.of(context).size.width > 800)
            Sidebar(
              currentRoute: widget.currentRoute,
              onRouteChanged: widget.onRouteChanged,
            ),
          // 主内容区
          Expanded(
            child: Column(
              children: [
                // 顶部栏
                Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      if (MediaQuery.of(context).size.width <= 800)
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                      Icon(Icons.dashboard, color: Colors.grey[400], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      // 通知
                      IconButton(
                        icon: Icon(Icons.notifications_outlined, color: Colors.grey[600]),
                        onPressed: () => _showNotifications(context),
                      ),
                      const SizedBox(width: 8),
                      // 用户信息
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.blue,
                              child: Text(
                                user?.displayName.isNotEmpty == true ? user!.displayName[0] : '?',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user?.displayName ?? '未登录',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.logout, color: Colors.grey[600], size: 20),
                        tooltip: '退出登录',
                        onPressed: () {
                          logout(ref);
                        },
                      ),
                    ],
                  ),
                ),
                // 内容区
                Expanded(
                  child: Container(
                    color: const Color(0xFFf1f5f9),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
