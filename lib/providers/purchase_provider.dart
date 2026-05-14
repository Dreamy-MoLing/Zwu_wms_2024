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

// 采购退货
final purchaseReturnListProvider = StateNotifierProvider<PurchaseReturnListNotifier, List<PurchaseReturn>>((ref) {
  return PurchaseReturnListNotifier();
});

class PurchaseReturnListNotifier extends StateNotifier<List<PurchaseReturn>> {
  PurchaseReturnListNotifier() : super([...mockPurchaseReturns]);

  void add(PurchaseReturn r) {
    state = [r, ...state];
  }

  void updateStatus(String id, String status) {
    state = state.map((r) => r.id == id ? _copyWithStatus(r, status) : r).toList();
  }

  void delete(String id) {
    state = state.where((r) => r.id != id).toList();
  }

  PurchaseReturn _copyWithStatus(PurchaseReturn r, String status) {
    return PurchaseReturn(id: r.id, supplierName: r.supplierName, reason: r.reason, returnDate: r.returnDate, status: status, amount: r.amount);
  }

  String generateId() {
    final count = state.length + 1;
    return 'PR${DateTime.now().year}${count.toString().padLeft(4, '0')}';
  }
}

final List<PurchaseReturn> mockPurchaseReturns = [
  PurchaseReturn(id: 'PR2025001', supplierName: '深圳华强电子有限公司', reason: '商品质量问题', returnDate: DateTime(2025, 5, 10), status: '待处理', amount: 5800),
  PurchaseReturn(id: 'PR2025002', supplierName: '广州办公用品批发', reason: '数量不符', returnDate: DateTime(2025, 5, 8), status: '已完成', amount: 1800),
];

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

// 销售退货
final salesReturnListProvider = StateNotifierProvider<SalesReturnListNotifier, List<SalesReturn>>((ref) {
  return SalesReturnListNotifier();
});

class SalesReturnListNotifier extends StateNotifier<List<SalesReturn>> {
  SalesReturnListNotifier() : super([...mockSalesReturns]);

  void add(SalesReturn r) {
    state = [r, ...state];
  }

  void updateStatus(String id, String status) {
    state = state.map((r) => r.id == id ? _copyWithStatus(r, status) : r).toList();
  }

  void delete(String id) {
    state = state.where((r) => r.id != id).toList();
  }

  SalesReturn _copyWithStatus(SalesReturn r, String status) {
    return SalesReturn(id: r.id, customerName: r.customerName, reason: r.reason, returnDate: r.returnDate, status: status, amount: r.amount);
  }

  String generateId() {
    final count = state.length + 1;
    return 'SR${DateTime.now().year}${count.toString().padLeft(4, '0')}';
  }
}

final List<SalesReturn> mockSalesReturns = [
  SalesReturn(id: 'SR2025001', customerName: '上海贸易商行', reason: '客户退货', returnDate: DateTime(2025, 5, 11), status: '待处理', amount: 6999),
  SalesReturn(id: 'SR2025002', customerName: '北京科技公司', reason: '商品损坏', returnDate: DateTime(2025, 5, 9), status: '已完成', amount: 2199),
  SalesReturn(id: 'SR2025003', customerName: '广州零售店', reason: '尺码不符', returnDate: DateTime(2025, 5, 7), status: '已完成', amount: 345),
];
