import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/system_provider.dart';
import '../../widgets/data_table_widget.dart';
import '../../widgets/form_dialogs/user_form_dialog.dart';
import '../../theme/theme.dart';

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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('用户管理', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    SizedBox(height: 4),
                    Text('管理系统中的用户账号与权限', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => UserFormDialog.show(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('新增用户'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
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
                  color: AppColors.bgPrimary,
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
                      onChanged: (_) => ref.read(userListProvider.notifier).toggleEnabled(user.id, (e) => e.copyWith(enabled: !e.enabled)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Row(
                      children: [
                        TextButton(
                          onPressed: () => UserFormDialog.show(context, user: user),
                          child: const Text('编辑', style: TextStyle(fontSize: 12)),
                        ),
                        TextButton(
                          onPressed: () => ref.read(userListProvider.notifier).delete(user.id),
                          child: const Text('删除', style: TextStyle(fontSize: 12, color: AppColors.error)),
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
      '超级管理员': AppColors.error,
      '采购员': AppColors.info,
      '销售员': AppColors.success,
      '库管员': AppColors.warning,
      '财务员': Colors.purple,
      '经理': AppColors.completed,
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

}
