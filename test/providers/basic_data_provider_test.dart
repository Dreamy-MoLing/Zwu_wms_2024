import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wms/models/product.dart';
import 'package:wms/models/supplier_customer.dart';
import 'package:wms/models/warehouse.dart';
import 'package:wms/providers/basic_data_provider.dart';

void main() {
  group('ProductListNotifier', () {
    test('initial state has mock data', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final products = container.read(productListProvider);
      expect(products.length, greaterThan(0));
      expect(products.first.name, '笔记本电脑');
    });

    test('adds a product', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(productListProvider.notifier).add(
        Product(id: 'P099', name: '测试商品', category: '其他', spec: '测试', unit: '个', purchasePrice: 10, salePrice: 20),
      );
      final products = container.read(productListProvider);
      expect(products.length, greaterThan(0));
      expect(products.any((p) => p.id == 'P099'), isTrue);
    });

    test('updates a product', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(productListProvider.notifier).add(
        Product(id: 'P099', name: '测试商品', category: '其他', spec: '测试', unit: '个', purchasePrice: 10, salePrice: 20),
      );
      container.read(productListProvider.notifier).update(
        Product(id: 'P099', name: '已更新', category: '其他', spec: '测试', unit: '个', purchasePrice: 15, salePrice: 25),
      );
      final products = container.read(productListProvider);
      final updated = products.firstWhere((p) => p.id == 'P099');
      expect(updated.name, '已更新');
      expect(updated.purchasePrice, 15);
    });

    test('deletes a product', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(productListProvider);
      final firstId = before.first.id;
      container.read(productListProvider.notifier).delete(firstId);
      final after = container.read(productListProvider);
      expect(after.length, before.length - 1);
      expect(after.any((p) => p.id == firstId), isFalse);
    });

    test('generateId creates sequential id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final id = container.read(productListProvider.notifier).generateId();
      expect(id, startsWith('P'));
      expect(int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), '')), greaterThan(0));
    });
  });

  group('SupplierListNotifier', () {
    test('adds a supplier', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(supplierListProvider.notifier).add(
        Supplier(id: 'S099', name: '测试供应商', contact: '联系人', phone: '123'),
      );
      final suppliers = container.read(supplierListProvider);
      expect(suppliers.any((s) => s.id == 'S099'), isTrue);
    });

    test('toggleEnabled toggles supplier enabled state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(supplierListProvider);
      final first = before.first;
      final initialEnabled = first.enabled;
      container.read(supplierListProvider.notifier).toggleEnabled(first.id, (s) => s.copyWith(enabled: !s.enabled));
      final after = container.read(supplierListProvider);
      expect(after.firstWhere((s) => s.id == first.id).enabled, !initialEnabled);
    });

    test('generateId creates sequential id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final id = container.read(supplierListProvider.notifier).generateId();
      expect(id, startsWith('S'));
    });
  });

  group('CustomerListNotifier', () {
    test('adds a customer', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(customerListProvider.notifier).add(
        Customer(id: 'C099', name: '测试客户', contact: '联系人', phone: '456'),
      );
      final customers = container.read(customerListProvider);
      expect(customers.any((c) => c.id == 'C099'), isTrue);
    });

    test('toggleEnabled toggles customer enabled state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(customerListProvider);
      final first = before.first;
      container.read(customerListProvider.notifier).toggleEnabled(first.id, (c) => c.copyWith(enabled: !c.enabled));
      final after = container.read(customerListProvider);
      expect(after.firstWhere((c) => c.id == first.id).enabled, !first.enabled);
    });
  });

  group('WarehouseListNotifier', () {
    test('adds a warehouse', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(warehouseListProvider.notifier).add(
        Warehouse(id: 'WH099', name: '测试仓库'),
      );
      final warehouses = container.read(warehouseListProvider);
      expect(warehouses.any((w) => w.id == 'WH099'), isTrue);
    });

    test('toggleEnabled toggles warehouse enabled state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(warehouseListProvider);
      final first = before.first;
      container.read(warehouseListProvider.notifier).toggleEnabled(first.id, (w) => w.copyWith(enabled: !w.enabled));
      final after = container.read(warehouseListProvider);
      expect(after.firstWhere((w) => w.id == first.id).enabled, !first.enabled);
    });
  });
}
