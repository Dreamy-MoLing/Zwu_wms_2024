import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/interfaces.dart';

class BaseListNotifier<T extends HasId> extends StateNotifier<List<T>> {
  BaseListNotifier(super.initial, {required String idPrefix}) : _idPrefix = idPrefix;

  final String _idPrefix;

  void add(T item) => state = [...state, item];

  void update(T item) {
    state = state.map((e) => e.id == item.id ? item : e).toList();
  }

  void delete(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void toggleEnabled(String id, T Function(T) toggle) {
    state = state.map((e) => e.id == id ? toggle(e) : e).toList();
  }

  String generateId() {
    final maxId = state
        .map((e) => int.tryParse(e.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .reduce((a, b) => a > b ? a : b);
    return '$_idPrefix${(maxId + 1).toString().padLeft(3, '0')}';
  }
}

class BaseOrderNotifier<T extends HasId> extends StateNotifier<List<T>> {
  BaseOrderNotifier(super.initial, {required String idPrefix}) : _idPrefix = idPrefix;

  final String _idPrefix;

  void add(T item) => state = [item, ...state];

  void delete(String id) {
    state = state.where((o) => o.id != id).toList();
  }

  void updateStatus(String id, T Function(T) update) {
    state = state.map((o) => o.id == id ? update(o) : o).toList();
  }

  String generateId() {
    final count = state.length + 1;
    return '$_idPrefix${DateTime.now().year}${count.toString().padLeft(4, '0')}';
  }
}
