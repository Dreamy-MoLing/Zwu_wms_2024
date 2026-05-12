import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final currentUserProvider = StateProvider<User?>((ref) => null);

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

void login(WidgetRef ref, String username, String password) {
  final user = mockUsers.where((u) => u.username == username).firstOrNull;
  if (user != null && password == '123456') {
    ref.read(currentUserProvider.notifier).state = user;
  } else {
    throw Exception('用户名或密码错误');
  }
}

void logout(WidgetRef ref) {
  ref.read(currentUserProvider.notifier).state = null;
}
