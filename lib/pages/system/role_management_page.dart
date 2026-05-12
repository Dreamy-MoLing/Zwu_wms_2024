import 'package:flutter/material.dart';

class RoleManagementPage extends StatelessWidget {
  const RoleManagementPage({super.key});

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
              Text('角色管理', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              const SizedBox(height: 4),
              Text('管理系统的角色与权限分配', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
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
                itemCount: _roles.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (_, i) {
                  final role = _roles[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: role.color.withValues(alpha: 0.1),
                      child: Icon(role.icon, color: role.color),
                    ),
                    title: Text(role.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${role.permissions.length} 项权限 · ${role.userCount} 人'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showRoleDetail(context, role),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRoleDetail(BuildContext context, _Role role) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${role.name} - 权限详情'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('用户数: ${role.userCount} 人', style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 16),
              const Text('权限列表:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...role.permissions.map((p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.check, color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    Text(p),
                  ],
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('关闭')),
        ],
      ),
    );
  }
}

class _Role {
  final String name;
  final IconData icon;
  final Color color;
  final int userCount;
  final List<String> permissions;
  _Role({required this.name, required this.icon, required this.color, required this.userCount, required this.permissions});
}

final List<_Role> _roles = [
  _Role(
    name: '超级管理员', icon: Icons.admin_panel_settings, color: Colors.red, userCount: 1,
    permissions: ['所有模块访问权限', '系统配置管理', '用户管理', '角色与权限分配', '数据导出', '报表查看'],
  ),
  _Role(
    name: '采购员', icon: Icons.shopping_cart, color: Colors.blue, userCount: 1,
    permissions: ['商品信息查看', '供应商管理', '采购订单管理', '采购退货管理', '采购报表查看'],
  ),
  _Role(
    name: '销售员', icon: Icons.point_of_sale, color: Colors.green, userCount: 2,
    permissions: ['商品信息查看', '客户管理', '销售订单管理', '销售退货管理', '销售报表查看'],
  ),
  _Role(
    name: '库管员', icon: Icons.inventory, color: Colors.orange, userCount: 1,
    permissions: ['商品信息查看', '库存查询', '库存盘点', '入库/出库操作', '库存报表查看'],
  ),
  _Role(
    name: '财务员', icon: Icons.account_balance, color: Colors.purple, userCount: 1,
    permissions: ['商品价格查看', '订单金额审核', '财务报表查看', '发票管理'],
  ),
  _Role(
    name: '经理', icon: Icons.engineering, color: Colors.teal, userCount: 0,
    permissions: ['所有模块查看权限', '报表查看', '数据导出', '审批操作'],
  ),
];
