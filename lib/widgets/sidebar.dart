import 'package:flutter/material.dart';

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
  MenuItem(label: '系统管理', icon: Icons.settings, children: [
    MenuItem(label: '用户管理', icon: Icons.person, route: '/system/users'),
    MenuItem(label: '角色管理', icon: Icons.admin_panel_settings, route: '/system/roles'),
  ]),
  MenuItem(label: '基础数据', icon: Icons.storage, children: [
    MenuItem(label: '商品管理', icon: Icons.inventory_2, route: '/basic/products'),
    MenuItem(label: '供应商管理', icon: Icons.business, route: '/basic/suppliers'),
    MenuItem(label: '客户管理', icon: Icons.people, route: '/basic/customers'),
    MenuItem(label: '仓库管理', icon: Icons.warehouse, route: '/basic/warehouses'),
  ]),
  MenuItem(label: '采购管理', icon: Icons.shopping_cart, children: [
    MenuItem(label: '采购订单', icon: Icons.receipt_long, route: '/purchase/orders'),
    MenuItem(label: '采购退货', icon: Icons.replay, route: '/purchase/returns'),
  ]),
  MenuItem(label: '销售管理', icon: Icons.point_of_sale, children: [
    MenuItem(label: '销售订单', icon: Icons.receipt, route: '/sales/orders'),
    MenuItem(label: '销售退货', icon: Icons.replay_circle_filled, route: '/sales/returns'),
  ]),
  MenuItem(label: '库存管理', icon: Icons.inventory, children: [
    MenuItem(label: '库存查询', icon: Icons.search, route: '/inventory/stock'),
    MenuItem(label: '库存盘点', icon: Icons.assignment, route: '/inventory/check'),
  ]),
  MenuItem(label: '报表管理', icon: Icons.bar_chart, children: [
    MenuItem(label: '销售报表', icon: Icons.show_chart, route: '/reports/sales'),
    MenuItem(label: '采购报表', icon: Icons.trending_up, route: '/reports/purchase'),
    MenuItem(label: '库存报表', icon: Icons.pie_chart, route: '/reports/inventory'),
  ]),
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
      width: 240,
      color: const Color(0xFF1e293b),
      child: Column(
        children: [
          // Logo
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.inventory_2, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('系统', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('企业进销存管理', style: TextStyle(color: Colors.white60, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          // Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: menuItems.map((item) => _buildMenuItem(item)).toList(),
            ),
          ),
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
        InkWell(
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? Colors.white.withValues(alpha: 0.1) : null,
              border: Border(
                left: BorderSide(
                  color: isActive ? Colors.blue : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(item.icon, color: Colors.white70, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
                  ),
                ),
                if (hasChildren)
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white54,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
        if (hasChildren && expanded)
          ...item.children.map((child) => _buildChildItem(child)),
      ],
    );
  }

  Widget _buildChildItem(MenuItem item) {
    final isActive = item.route == widget.currentRoute;
    return InkWell(
      onTap: () => widget.onRouteChanged(item.route),
      child: Container(
        padding: const EdgeInsets.only(left: 56, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withValues(alpha: 0.15) : null,
        ),
        child: Row(
          children: [
            Icon(item.icon, color: isActive ? Colors.blue : Colors.white54, size: 16),
            const SizedBox(width: 8),
            Text(
              item.label,
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
