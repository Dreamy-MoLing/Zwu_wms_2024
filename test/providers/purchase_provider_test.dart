import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wms/models/order.dart';
import 'package:wms/providers/purchase_provider.dart';

void main() {
  group('PurchaseOrderListNotifier', () {
    test('adds a purchase order', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final item = OrderItem(productId: 'P001', productName: '测试', spec: '规格', unit: '个', quantity: 1, price: 100);
      container.read(purchaseOrderListProvider.notifier).add(
        PurchaseOrder(id: 'PO9999', supplierName: '测试供应商', orderDate: DateTime(2025, 5, 1), items: [item], handler: '测试员'),
      );
      final orders = container.read(purchaseOrderListProvider);
      expect(orders.any((o) => o.id == 'PO9999'), isTrue);
    });

    test('updateStatus changes order status via callback', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(purchaseOrderListProvider);
      final first = before.firstWhere((o) => o.status == '待审核');
      container.read(purchaseOrderListProvider.notifier).updateStatus(first.id, (o) => o.copyWith(status: '已通过'));
      final after = container.read(purchaseOrderListProvider);
      expect(after.firstWhere((o) => o.id == first.id).status, '已通过');
    });

    test('deletes an order', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(purchaseOrderListProvider);
      final firstId = before.first.id;
      container.read(purchaseOrderListProvider.notifier).delete(firstId);
      final after = container.read(purchaseOrderListProvider);
      expect(after.length, before.length - 1);
    });

    test('generateId returns prefixed id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final id = container.read(purchaseOrderListProvider.notifier).generateId();
      expect(id, startsWith('PO'));
    });
  });

  group('PurchaseReturnListNotifier', () {
    test('adds a purchase return', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(purchaseReturnListProvider.notifier).add(
        PurchaseReturn(id: 'PR9999', supplierName: '测试供应商', returnDate: DateTime.now()),
      );
      final returns = container.read(purchaseReturnListProvider);
      expect(returns.any((r) => r.id == 'PR9999'), isTrue);
    });

    test('updateStatus changes return status', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(purchaseReturnListProvider);
      final first = before.first;
      container.read(purchaseReturnListProvider.notifier).updateStatus(first.id, (r) => r.copyWith(status: '已完成'));
      final after = container.read(purchaseReturnListProvider);
      expect(after.firstWhere((r) => r.id == first.id).status, '已完成');
    });
  });

  group('SalesOrderListNotifier', () {
    test('adds a sales order', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final item = OrderItem(productId: 'P001', productName: '测试', spec: '规格', unit: '个', quantity: 1, price: 100);
      container.read(salesOrderListProvider.notifier).add(
        SalesOrder(id: 'SO9999', customerName: '测试客户', orderDate: DateTime(2025, 5, 1), items: [item], handler: '测试员'),
      );
      final orders = container.read(salesOrderListProvider);
      expect(orders.any((o) => o.id == 'SO9999'), isTrue);
    });

    test('updateStatus changes order status', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(salesOrderListProvider);
      final first = before.firstWhere((o) => o.status == '待审核');
      container.read(salesOrderListProvider.notifier).updateStatus(first.id, (o) => o.copyWith(status: '已通过'));
      final after = container.read(salesOrderListProvider);
      expect(after.firstWhere((o) => o.id == first.id).status, '已通过');
    });
  });

  group('SalesReturnListNotifier', () {
    test('adds a sales return', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(salesReturnListProvider.notifier).add(
        SalesReturn(id: 'SR9999', customerName: '测试客户', returnDate: DateTime.now()),
      );
      final returns = container.read(salesReturnListProvider);
      expect(returns.any((r) => r.id == 'SR9999'), isTrue);
    });

    test('updateStatus changes return status', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(salesReturnListProvider);
      final first = before.first;
      container.read(salesReturnListProvider.notifier).updateStatus(first.id, (r) => r.copyWith(status: '已完成'));
      final after = container.read(salesReturnListProvider);
      expect(after.firstWhere((r) => r.id == first.id).status, '已完成');
    });
  });

  group('PurchaseReturn/SalesReturn copyWith', () {
    test('PurchaseReturn copyWith changes specific fields', () {
      final r = PurchaseReturn(id: 'PR001', supplierName: '供应商', reason: '质量问题', returnDate: DateTime(2025, 1, 1), status: '待处理', amount: 100);
      final updated = r.copyWith(status: '已完成', amount: 200);
      expect(updated.id, 'PR001');
      expect(updated.status, '已完成');
      expect(updated.amount, 200);
      expect(updated.supplierName, '供应商');
    });

    test('SalesReturn copyWith changes specific fields', () {
      final r = SalesReturn(id: 'SR001', customerName: '客户', reason: '退货', returnDate: DateTime(2025, 1, 1), status: '待处理', amount: 100);
      final updated = r.copyWith(status: '已完成');
      expect(updated.id, 'SR001');
      expect(updated.status, '已完成');
      expect(updated.customerName, '客户');
    });
  });
}
