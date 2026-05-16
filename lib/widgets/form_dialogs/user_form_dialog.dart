import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../providers/system_provider.dart';
import '../../theme/theme.dart';

class UserFormDialog extends ConsumerStatefulWidget {
  final User? user;

  const UserFormDialog({super.key, this.user});

  static Future<void> show(BuildContext context, {User? user}) {
    return showDialog<void>(
      context: context,
      builder: (_) => UserFormDialog(user: user),
    );
  }

  @override
  ConsumerState<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends ConsumerState<UserFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late String _selectedRole;

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _nameCtrl = TextEditingController(text: u?.displayName ?? '');
    _usernameCtrl = TextEditingController(text: u?.username ?? '');
    _phoneCtrl = TextEditingController(text: u?.phone ?? '');
    _emailCtrl = TextEditingController(text: u?.email ?? '');
    _selectedRole = u?.role ?? '采购员';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? '编辑用户' : '新增用户'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: '姓名', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(labelText: '用户名', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(labelText: '角色', border: OutlineInputBorder()),
                items: roleOptions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => _selectedRole = v!),
              ),
              if (!_isEdit) ...[
                const SizedBox(height: 12),
                const Text('默认密码: 123456', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: '手机号', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: '邮箱', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
        ElevatedButton(onPressed: _submit, child: Text(_isEdit ? '保存' : '添加')),
      ],
    );
  }

  void _submit() {
    final notifier = ref.read(userListProvider.notifier);
    if (_isEdit) {
      notifier.update(widget.user!.copyWith(
        displayName: _nameCtrl.text,
        username: _usernameCtrl.text,
        role: _selectedRole,
        phone: _phoneCtrl.text,
        email: _emailCtrl.text,
      ));
    } else {
      notifier.add(User(
        id: notifier.generateId(),
        username: _usernameCtrl.text,
        displayName: _nameCtrl.text,
        role: _selectedRole,
        phone: _phoneCtrl.text,
        email: _emailCtrl.text,
      ));
    }
    Navigator.pop(context);
  }
}
