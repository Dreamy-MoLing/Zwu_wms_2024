import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import 'base_list_notifier.dart';

// 采购订单
final purchaseOrderListProvider = StateNotifierProvider<PurchaseOrderListNotifier, List<PurchaseOrder>>((ref) {
  return PurchaseOrderListNotifier();
});

class PurchaseOrderListNotifier extends BaseOrderNotifier<PurchaseOrder> {
  PurchaseOrderListNotifier() : super([...mockPurchaseOrders], idPrefix: 'PO');
}

// 采购退货
final purchaseReturnListProvider = StateNotifierProvider<PurchaseReturnListNotifier, List<PurchaseReturn>>((ref) {
  return PurchaseReturnListNotifier();
});

class PurchaseReturnListNotifier extends BaseOrderNotifier<PurchaseReturn> {
  PurchaseReturnListNotifier() : super([...mockPurchaseReturns], idPrefix: 'PR');
}

final List<PurchaseReturn> mockPurchaseReturns = [
  PurchaseReturn(id: 'PR2025001', supplierName: '深圳华强电子有限公司', reason: '商品质量问题', returnDate: DateTime(2025, 5, 10), status: '待处理', amount: 5800),
  PurchaseReturn(id: 'PR2025002', supplierName: '广州办公用品批发', reason: '数量不符', returnDate: DateTime(2025, 5, 8), status: '已完成', amount: 1800),
];

// 销售订单
final salesOrderListProvider = StateNotifierProvider<SalesOrderListNotifier, List<SalesOrder>>((ref) {
  return SalesOrderListNotifier();
});

class SalesOrderListNotifier extends BaseOrderNotifier<SalesOrder> {
  SalesOrderListNotifier() : super([...mockSalesOrders], idPrefix: 'SO');
}

// 销售退货
final salesReturnListProvider = StateNotifierProvider<SalesReturnListNotifier, List<SalesReturn>>((ref) {
  return SalesReturnListNotifier();
});

class SalesReturnListNotifier extends BaseOrderNotifier<SalesReturn> {
  SalesReturnListNotifier() : super([...mockSalesReturns], idPrefix: 'SR');
}

final List<SalesReturn> mockSalesReturns = [
  SalesReturn(id: 'SR2025001', customerName: '上海贸易商行', reason: '客户退货', returnDate: DateTime(2025, 5, 11), status: '待处理', amount: 6999),
  SalesReturn(id: 'SR2025002', customerName: '北京科技公司', reason: '商品损坏', returnDate: DateTime(2025, 5, 9), status: '已完成', amount: 2199),
  SalesReturn(id: 'SR2025003', customerName: '广州零售店', reason: '尺码不符', returnDate: DateTime(2025, 5, 7), status: '已完成', amount: 345),
];
