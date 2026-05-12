import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../providers/system_provider.dart';
import '../../widgets/data_table_widget.dart';

class UserManagementPage extends ConsumerWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userListProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('用户管理', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                    const SizedBox(height: 4),
                    Text('管理系统中的用户账号与权限', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showUserDialog(context, ref, null),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('新增用户'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
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
                child: DataTableWidget(
                  columns: const [
                    DataColumn(label: Text('编号')),
                    DataColumn(label: Text('用户名')),
                    DataColumn(label: Text('姓名')),
                    DataColumn(label: Text('角色')),
                    DataColumn(label: Text('手机号')),
                    DataColumn(label: Text('邮箱')),
                    DataColumn(label: Text('状态')),
                    DataColumn(label: Text('操作')),
                  ],
                  rows: users.map((user) => DataRow(cells: [
                    DataCell(Text(user.id)),
                    DataCell(Text(user.username)),
                    DataCell(Text(user.displayName)),
                    DataCell(_buildRoleChip(user.role)),
                    DataCell(Text(user.phone)),
                    DataCell(Text(user.email)),
                    DataCell(Switch(
                      value: user.enabled,
                      onChanged: (_) => ref.read(userListProvider.notifier).toggleEnabled(user.id),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Row(
                      children: [
                        TextButton(
                          onPressed: () => _showUserDialog(context, ref, user),
                          child: const Text('编辑', style: TextStyle(fontSize: 12)),
                        ),
                        TextButton(
                          onPressed: () => ref.read(userListProvider.notifier).deleteUser(user.id),
                          child: const Text('删除', style: TextStyle(fontSize: 12, color: Colors.red)),
                        ),
                      ],
                    )),
                  ])).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    final colors = {
      '超级管理员': Colors.red,
      '采购员': Colors.blue,
      '销售员': Colors.green,
      '库管员': Colors.orange,
      '财务员': Colors.purple,
      '经理': Colors.teal,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: (colors[role] ?? Colors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(role, style: TextStyle(fontSize: 12, color: colors[role] ?? Colors.grey)),
    );
  }

  void _showUserDialog(BuildContext context, WidgetRef ref, User? user) {
    final isEdit = user != null;
    final nameCtrl = TextEditingController(text: user?.displayName ?? '');
    final usernameCtrl = TextEditingController(text: user?.username ?? '');
    final phoneCtrl = TextEditingController(text: user?.phone ?? '');
    final emailCtrl = TextEditingController(text: user?.email ?? '');
    String selectedRole = user?.role ?? '采购员';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(isEdit ? '编辑用户' : '新增用户'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: '姓名', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: usernameCtrl,
                    decoration: const InputDecoration(labelText: '用户名', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    key: ValueKey(selectedRole),
                    initialValue: selectedRole,
                    decoration: const InputDecoration(labelText: '角色', border: OutlineInputBorder()),
                    items: roleOptions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (v) => setState(() => selectedRole = v!),
                  ),
                  if (!isEdit) ...[
                    const SizedBox(height: 12),
                    Text('默认密码: 123456', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneCtrl,
                    decoration: const InputDecoration(labelText: '手机号', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: '邮箱', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
            ElevatedButton(
              onPressed: () {
                final notifier = ref.read(userListProvider.notifier);
                if (isEdit) {
                  notifier.updateUser(user.copyWith(
                    displayName: nameCtrl.text,
                    username: usernameCtrl.text,
                    role: selectedRole,
                    phone: phoneCtrl.text,
                    email: emailCtrl.text,
                  ));
                } else {
                  notifier.addUser(User(
                    id: notifier.generateId(),
                    username: usernameCtrl.text,
                    displayName: nameCtrl.text,
                    role: selectedRole,
                    phone: phoneCtrl.text,
                    email: emailCtrl.text,
                  ));
                }
                Navigator.pop(ctx);
              },
              child: Text(isEdit ? '保存' : '添加'),
            ),
          ],
        ),
      ),
    );
  }
}
