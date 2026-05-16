import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../models/supplier_customer.dart';
import '../models/warehouse.dart';
import 'base_list_notifier.dart';

// 产品
final productListProvider = StateNotifierProvider<ProductListNotifier, List<Product>>((ref) {
  return ProductListNotifier();
});

class ProductListNotifier extends BaseListNotifier<Product> {
  ProductListNotifier() : super([...mockProducts], idPrefix: 'P');
}

// 供应商
final supplierListProvider = StateNotifierProvider<SupplierListNotifier, List<Supplier>>((ref) {
  return SupplierListNotifier();
});

class SupplierListNotifier extends BaseListNotifier<Supplier> {
  SupplierListNotifier() : super([...mockSuppliers], idPrefix: 'S');
}

// 客户
final customerListProvider = StateNotifierProvider<CustomerListNotifier, List<Customer>>((ref) {
  return CustomerListNotifier();
});

class CustomerListNotifier extends BaseListNotifier<Customer> {
  CustomerListNotifier() : super([...mockCustomers], idPrefix: 'C');
}

// 仓库
final warehouseListProvider = StateNotifierProvider<WarehouseListNotifier, List<Warehouse>>((ref) {
  return WarehouseListNotifier();
});

class WarehouseListNotifier extends BaseListNotifier<Warehouse> {
  WarehouseListNotifier() : super([...mockWarehouses], idPrefix: 'WH');
}
