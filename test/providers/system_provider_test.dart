import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wms/models/user.dart';
import 'package:wms/providers/system_provider.dart';

void main() {
  group('UserListNotifier', () {
    test('initial state has mock users', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final users = container.read(userListProvider);
      expect(users.length, greaterThan(0));
      expect(users.any((u) => u.username == 'admin'), isTrue);
    });

    test('adds a user', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(userListProvider.notifier).add(
        User(id: 'U099', username: 'testuser', displayName: '测试用户', role: '采购员'),
      );
      final users = container.read(userListProvider);
      expect(users.any((u) => u.id == 'U099'), isTrue);
    });

    test('updates a user', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(userListProvider.notifier).add(
        User(id: 'U099', username: 'testuser', displayName: '测试用户', role: '采购员'),
      );
      container.read(userListProvider.notifier).update(
        User(id: 'U099', username: 'testuser', displayName: '已更新', role: '销售员'),
      );
      final users = container.read(userListProvider);
      final updated = users.firstWhere((u) => u.id == 'U099');
      expect(updated.displayName, '已更新');
      expect(updated.role, '销售员');
    });

    test('deletes a user', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(userListProvider);
      final firstId = before.first.id;
      container.read(userListProvider.notifier).delete(firstId);
      final after = container.read(userListProvider);
      expect(after.length, before.length - 1);
      expect(after.any((u) => u.id == firstId), isFalse);
    });

    test('toggleEnabled toggles user enabled state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(userListProvider);
      final first = before.first;
      container.read(userListProvider.notifier).toggleEnabled(first.id, (u) => u.copyWith(enabled: !u.enabled));
      final after = container.read(userListProvider);
      expect(after.firstWhere((u) => u.id == first.id).enabled, !first.enabled);
    });

    test('generateId returns prefixed id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final id = container.read(userListProvider.notifier).generateId();
      expect(id, startsWith('U'));
    });

    test('User copyWith preserves unchanged fields', () {
      final user = User(id: 'U001', username: 'admin', displayName: '管理员', role: '超级管理员', phone: '123', email: 'a@b.com');
      final updated = user.copyWith(displayName: '新名字');
      expect(updated.id, 'U001');
      expect(updated.username, 'admin');
      expect(updated.displayName, '新名字');
      expect(updated.role, '超级管理员');
    });
  });
}
