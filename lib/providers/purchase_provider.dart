import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';

// 采购订单
final purchaseOrderListProvider = StateNotifierProvider<PurchaseOrderListNotifier, List<PurchaseOrder>>((ref) {
  return PurchaseOrderListNotifier();
});

class PurchaseOrderListNotifier extends StateNotifier<List<PurchaseOrder>> {
  PurchaseOrderListNotifier() : super([...mockPurchaseOrders]);

  void add(PurchaseOrder o) {
    state = [o, ...state];
  }

  void updateStatus(String id, String status) {
    state = state.map((o) => o.id == id ? o.copyWith(status: status) : o).toList();
  }

  void delete(String id) {
    state = state.where((o) => o.id != id).toList();
  }

  String generateId() {
    final count = state.length + 1;
    return 'PO${DateTime.now().year}${count.toString().padLeft(4, '0')}';
  }
}

// 销售订单
final salesOrderListProvider = StateNotifierProvider<SalesOrderListNotifier, List<SalesOrder>>((ref) {
  return SalesOrderListNotifier();
});

class SalesOrderListNotifier extends StateNotifier<List<SalesOrder>> {
  SalesOrderListNotifier() : super([...mockSalesOrders]);

  void add(SalesOrder o) {
    state = [o, ...state];
  }

  void updateStatus(String id, String status) {
    state = state.map((o) => o.id == id ? o.copyWith(status: status) : o).toList();
  }

  void delete(String id) {
    state = state.where((o) => o.id != id).toList();
  }

  String generateId() {
    final count = state.length + 1;
    return 'SO${DateTime.now().year}${count.toString().padLeft(4, '0')}';
  }
}
