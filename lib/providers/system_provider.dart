import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import 'base_list_notifier.dart';

final userListProvider = StateNotifierProvider<UserListNotifier, List<User>>((ref) {
  return UserListNotifier();
});

class UserListNotifier extends BaseListNotifier<User> {
  UserListNotifier() : super([...mockUsers], idPrefix: 'U');
}
