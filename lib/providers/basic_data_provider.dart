import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../models/supplier_customer.dart';
import '../models/warehouse.dart';

// 产品
final productListProvider = StateNotifierProvider<ProductListNotifier, List<Product>>((ref) {
  return ProductListNotifier();
});

class ProductListNotifier extends StateNotifier<List<Product>> {
  ProductListNotifier() : super([...mockProducts]);

  void addProduct(Product p) {
    state = [...state, p];
  }

  void updateProduct(Product p) {
    state = state.map((e) => e.id == p.id ? p : e).toList();
  }

  void deleteProduct(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  String generateId() {
    final maxId = state.map((e) => int.tryParse(e.id.replaceAll('P', '')) ?? 0).reduce((a, b) => a > b ? a : b);
    return 'P${(maxId + 1).toString().padLeft(3, '0')}';
  }
}

// 供应商
final supplierListProvider = StateNotifierProvider<SupplierListNotifier, List<Supplier>>((ref) {
  return SupplierListNotifier();
});

class SupplierListNotifier extends StateNotifier<List<Supplier>> {
  SupplierListNotifier() : super([...mockSuppliers]);

  void add(Supplier s) {
    state = [...state, s];
  }

  void update(Supplier s) {
    state = state.map((e) => e.id == s.id ? s : e).toList();
  }

  void delete(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void toggleEnabled(String id) {
    state = state.map((e) => e.id == id ? e.copyWith(enabled: !e.enabled) : e).toList();
  }

  String generateId() {
    final maxId = state.map((e) => int.tryParse(e.id.replaceAll('S', '')) ?? 0).reduce((a, b) => a > b ? a : b);
    return 'S${(maxId + 1).toString().padLeft(3, '0')}';
  }
}

// 客户
final customerListProvider = StateNotifierProvider<CustomerListNotifier, List<Customer>>((ref) {
  return CustomerListNotifier();
});

class CustomerListNotifier extends StateNotifier<List<Customer>> {
  CustomerListNotifier() : super([...mockCustomers]);

  void add(Customer c) {
    state = [...state, c];
  }

  void update(Customer c) {
    state = state.map((e) => e.id == c.id ? c : e).toList();
  }

  void delete(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void toggleEnabled(String id) {
    state = state.map((e) => e.id == id ? e.copyWith(enabled: !e.enabled) : e).toList();
  }

  String generateId() {
    final maxId = state.map((e) => int.tryParse(e.id.replaceAll('C', '')) ?? 0).reduce((a, b) => a > b ? a : b);
    return 'C${(maxId + 1).toString().padLeft(3, '0')}';
  }
}

// 仓库
final warehouseListProvider = StateNotifierProvider<WarehouseListNotifier, List<Warehouse>>((ref) {
  return WarehouseListNotifier();
});

class WarehouseListNotifier extends StateNotifier<List<Warehouse>> {
  WarehouseListNotifier() : super([...mockWarehouses]);

  void add(Warehouse w) {
    state = [...state, w];
  }

  void update(Warehouse w) {
    state = state.map((e) => e.id == w.id ? w : e).toList();
  }

  void delete(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void toggleEnabled(String id) {
    state = state.map((e) => e.id == id ? e.copyWith(enabled: !e.enabled) : e).toList();
  }

  String generateId() {
    final maxId = state.map((e) => int.tryParse(e.id.replaceAll('WH', '')) ?? 0).reduce((a, b) => a > b ? a : b);
    return 'WH${(maxId + 1).toString().padLeft(3, '0')}';
  }
}
