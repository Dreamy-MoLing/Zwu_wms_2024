import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final userListProvider = StateNotifierProvider<UserListNotifier, List<User>>((ref) {
  return UserListNotifier();
});

class UserListNotifier extends StateNotifier<List<User>> {
  UserListNotifier() : super([...mockUsers]);

  void addUser(User user) {
    state = [...state, user];
  }

  void updateUser(User user) {
    state = state.map((u) => u.id == user.id ? user : u).toList();
  }

  void deleteUser(String id) {
    state = state.where((u) => u.id != id).toList();
  }

  void toggleEnabled(String id) {
    state = state.map((u) {
      if (u.id == id) return u.copyWith(enabled: !u.enabled);
      return u;
    }).toList();
  }

  String generateId() {
    final maxId = state.map((e) => int.tryParse(e.id.replaceAll('U', '')) ?? 0).reduce((a, b) => a > b ? a : b);
    return 'U${(maxId + 1).toString().padLeft(3, '0')}';
  }
}
