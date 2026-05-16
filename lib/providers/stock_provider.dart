import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/interfaces.dart';

class StockCheckRecord with HasId {
  @override final String id;
  final String category;
  final String handler;
  final DateTime date;
  final String status;

  StockCheckRecord({
    required this.id,
    required this.category,
    required this.handler,
    required this.date,
    required this.status,
  });

  StockCheckRecord copyWith({
    String? id,
    String? category,
    String? handler,
    DateTime? date,
    String? status,
  }) {
    return StockCheckRecord(
      id: id ?? this.id,
      category: category ?? this.category,
      handler: handler ?? this.handler,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}

final stockCheckListProvider = StateNotifierProvider<StockCheckListNotifier, List<StockCheckRecord>>((ref) {
  return StockCheckListNotifier();
});

class StockCheckListNotifier extends StateNotifier<List<StockCheckRecord>> {
  StockCheckListNotifier() : super(_mockRecords);

  void completeCheck(String id) {
    state = state.map((r) => r.id == id ? r.copyWith(status: '已完成') : r).toList();
  }

  static final List<StockCheckRecord> _mockRecords = [
    StockCheckRecord(id: 'CHK2025001', category: '电子产品', handler: '王五', date: DateTime(2025, 5, 12), status: '进行中'),
    StockCheckRecord(id: 'CHK2025002', category: '办公用品', handler: '王五', date: DateTime(2025, 5, 10), status: '已完成'),
    StockCheckRecord(id: 'CHK2025003', category: '家具', handler: '王五', date: DateTime(2025, 5, 8), status: '已完成'),
    StockCheckRecord(id: 'CHK2025004', category: '食品饮料', handler: '', date: DateTime(2025, 5, 15), status: '待盘点'),
    StockCheckRecord(id: 'CHK2025005', category: '服装鞋帽', handler: '', date: DateTime(2025, 5, 16), status: '待盘点'),
  ];
}
