import 'interfaces.dart';

class User with HasId, HasEnabled {
  @override final String id;
  final String username;
  final String displayName;
  final String role;
  final String phone;
  final String email;
  @override final bool enabled;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    this.phone = '',
    this.email = '',
    this.enabled = true,
  });

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? role,
    String? phone,
    String? email,
    bool? enabled,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      enabled: enabled ?? this.enabled,
    );
  }
}

final List<User> mockUsers = [
  User(id: 'U001', username: 'admin', displayName: '系统管理员', role: '超级管理员', phone: '13800000001', email: 'admin@wms.com'),
  User(id: 'U002', username: 'zhangsan', displayName: '张三', role: '采购员', phone: '13800000002', email: 'zhangsan@wms.com'),
  User(id: 'U003', username: 'lisi', displayName: '李四', role: '销售员', phone: '13800000003', email: 'lisi@wms.com'),
  User(id: 'U004', username: 'wangwu', displayName: '王五', role: '库管员', phone: '13800000004', email: 'wangwu@wms.com'),
  User(id: 'U005', username: 'zhaoliu', displayName: '赵六', role: '财务员', phone: '13800000005', email: 'zhaoliu@wms.com'),
  User(id: 'U006', username: 'sunqi', displayName: '孙七', role: '销售员', phone: '13800000006', email: 'sunqi@wms.com'),
];

final List<String> roleOptions = ['超级管理员', '采购员', '销售员', '库管员', '财务员', '经理'];
