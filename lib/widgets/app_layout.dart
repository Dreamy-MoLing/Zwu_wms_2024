import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme.dart';
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
        title: Row(
          children: [
            Icon(Icons.notifications, size: 22, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Text('通知', style: AppTypography.h5),
          ],
        ),
        content: SizedBox(
          width: 360,
          child: ListView(
            shrinkWrap: true,
            children: [
              _notificationItem(
                '采购订单 PO-2024-001 已入库',
                '5 分钟前',
                Icons.shopping_cart,
                AppColors.info,
              ),
              const Divider(height: 1),
              _notificationItem(
                '销售单 SO-2024-008 已出库',
                '30 分钟前',
                Icons.point_of_sale,
                AppColors.success,
              ),
              const Divider(height: 1),
              _notificationItem(
                '商品"无线鼠标"库存不足（当前库存：2）',
                '2 小时前',
                Icons.inventory,
                AppColors.warning,
              ),
              const Divider(height: 1),
              _notificationItem(
                '库存盘点完成，差异已记录',
                '昨天',
                Icons.assignment,
                AppColors.info,
              ),
              const Divider(height: 1),
              _notificationItem(
                '新客户"深圳科技有限公司"已注册',
                '昨天',
                Icons.person_add,
                AppColors.success,
              ),
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

  Widget _notificationItem(
    String text,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: AppTypography.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(time, style: AppTypography.caption),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > 800;

    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          // 侧边栏 - Web 端总是显示
          if (showSidebar)
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
                  height: AppSpacing.heightAppBar,
                  decoration: BoxDecoration(
                    color: AppColors.bgPrimary,
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.borderLight,
                        width: AppSpacing.borderNormal,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      // 移动端菜单按钮
                      if (!showSidebar)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.md),
                          child: IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                          ),
                        ),
                      // 页面标题
                      Icon(Icons.dashboard, color: AppColors.primary, size: 20),
                      const SizedBox(width: AppSpacing.md),
                      Text(widget.title, style: AppTypography.h5),
                      const Spacer(),
                      // 通知按钮
                      IconButton(
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => _showNotifications(context),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      // 用户信息
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgSecondary,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusXL,
                          ),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                user?.displayName.isNotEmpty == true
                                    ? user!.displayName[0]
                                    : '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              user?.displayName ?? '未登录',
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      // 登出按钮
                      IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
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
                    color: AppColors.bgTertiary,
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
