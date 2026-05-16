import 'package:flutter/material.dart';
import '../theme/theme.dart';

class MenuItem {
  final String label;
  final IconData icon;
  final String route;
  final List<MenuItem> children;

  MenuItem({
    required this.label,
    required this.icon,
    this.route = '',
    this.children = const [],
  });
}

final List<MenuItem> menuItems = [
  MenuItem(label: '首页', icon: Icons.dashboard, route: '/dashboard'),
  MenuItem(
    label: '系统管理',
    icon: Icons.settings,
    children: [
      MenuItem(label: '用户管理', icon: Icons.person, route: '/system/users'),
      MenuItem(
        label: '角色管理',
        icon: Icons.admin_panel_settings,
        route: '/system/roles',
      ),
    ],
  ),
  MenuItem(
    label: '基础数据',
    icon: Icons.storage,
    children: [
      MenuItem(
        label: '商品管理',
        icon: Icons.inventory_2,
        route: '/basic/products',
      ),
      MenuItem(label: '供应商管理', icon: Icons.business, route: '/basic/suppliers'),
      MenuItem(label: '客户管理', icon: Icons.people, route: '/basic/customers'),
      MenuItem(
        label: '仓库管理',
        icon: Icons.warehouse,
        route: '/basic/warehouses',
      ),
    ],
  ),
  MenuItem(
    label: '采购管理',
    icon: Icons.shopping_cart,
    children: [
      MenuItem(
        label: '采购订单',
        icon: Icons.receipt_long,
        route: '/purchase/orders',
      ),
      MenuItem(label: '采购退货', icon: Icons.replay, route: '/purchase/returns'),
    ],
  ),
  MenuItem(
    label: '销售管理',
    icon: Icons.point_of_sale,
    children: [
      MenuItem(label: '销售订单', icon: Icons.receipt, route: '/sales/orders'),
      MenuItem(
        label: '销售退货',
        icon: Icons.replay_circle_filled,
        route: '/sales/returns',
      ),
    ],
  ),
  MenuItem(
    label: '库存管理',
    icon: Icons.inventory,
    children: [
      MenuItem(label: '库存查询', icon: Icons.search, route: '/inventory/stock'),
      MenuItem(
        label: '库存盘点',
        icon: Icons.assignment,
        route: '/inventory/check',
      ),
    ],
  ),
  MenuItem(
    label: '报表管理',
    icon: Icons.bar_chart,
    children: [
      MenuItem(label: '销售报表', icon: Icons.show_chart, route: '/reports/sales'),
      MenuItem(
        label: '采购报表',
        icon: Icons.trending_up,
        route: '/reports/purchase',
      ),
      MenuItem(
        label: '库存报表',
        icon: Icons.pie_chart,
        route: '/reports/inventory',
      ),
    ],
  ),
];

class Sidebar extends StatefulWidget {
  final String currentRoute;
  final ValueChanged<String> onRouteChanged;

  const Sidebar({
    super.key,
    required this.currentRoute,
    required this.onRouteChanged,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final Set<String> _expandedLabels = {};

  @override
  void initState() {
    super.initState();
    _expandToCurrentRoute();
  }

  @override
  void didUpdateWidget(Sidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentRoute != widget.currentRoute) {
      _expandToCurrentRoute();
    }
  }

  void _expandToCurrentRoute() {
    for (final item in menuItems) {
      for (final child in item.children) {
        if (child.route == widget.currentRoute) {
          _expandedLabels.add(item.label);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.widthSidebar,
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: AppSpacing.elevationLarge,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo 区域
          Container(
            height: AppSpacing.heightAppBar,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: AppSpacing.borderNormal,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '企业管理',
                        style: AppTypography.label.copyWith(
                          color: Colors.white,
                          fontWeight: AppTypography.weightSemiBold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '进销存系统',
                        style: AppTypography.captionSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 菜单项列表
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: menuItems.map((item) => _buildMenuItem(item)).toList(),
            ),
          ),
          // 底部间隔
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    final hasChildren = item.children.isNotEmpty;
    final expanded = _expandedLabels.contains(item.label);
    final isActive = !hasChildren && item.route == widget.currentRoute;

    return Column(
      children: [
        _MenuItemButton(
          label: item.label,
          icon: item.icon,
          isActive: isActive,
          hasChildren: hasChildren,
          expanded: expanded,
          onTap: () {
            if (hasChildren) {
              setState(() {
                if (expanded) {
                  _expandedLabels.remove(item.label);
                } else {
                  _expandedLabels.add(item.label);
                }
              });
            } else {
              widget.onRouteChanged(item.route);
            }
          },
        ),
        if (hasChildren && expanded)
          ...item.children.map((child) => _buildChildItem(child)),
      ],
    );
  }

  Widget _buildChildItem(MenuItem item) {
    final isActive = item.route == widget.currentRoute;
    return _ChildMenuItemButton(
      label: item.label,
      icon: item.icon,
      isActive: isActive,
      onTap: () => widget.onRouteChanged(item.route),
    );
  }
}

class _MenuItemButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool hasChildren;
  final bool expanded;
  final VoidCallback onTap;

  const _MenuItemButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.hasChildren,
    required this.expanded,
    required this.onTap,
  });

  @override
  State<_MenuItemButton> createState() => _MenuItemButtonState();
}

class _MenuItemButtonState extends State<_MenuItemButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? Colors.white.withValues(alpha: 0.15)
                : _isHovered
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
            border: widget.isActive
                ? const Border(left: BorderSide(color: Colors.white, width: 3))
                : null,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: widget.isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.7),
                size: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  widget.label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: widget.isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.7),
                    fontWeight: widget.isActive
                        ? AppTypography.weightMedium
                        : AppTypography.weightRegular,
                  ),
                ),
              ),
              if (widget.hasChildren)
                Icon(
                  widget.expanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChildMenuItemButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ChildMenuItemButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_ChildMenuItemButton> createState() => _ChildMenuItemButtonState();
}

class _ChildMenuItemButtonState extends State<_ChildMenuItemButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? Colors.blue.withValues(alpha: 0.2)
                : _isHovered
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusNormal),
          ),
          padding: const EdgeInsets.only(
            left: AppSpacing.lg + AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: widget.isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5),
                size: 16,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                widget.label,
                style: AppTypography.bodySmall.copyWith(
                  color: widget.isActive
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.6),
                  fontWeight: widget.isActive
                      ? AppTypography.weightMedium
                      : AppTypography.weightRegular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
