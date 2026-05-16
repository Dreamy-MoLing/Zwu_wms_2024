import 'interfaces.dart';

class OrderItem {
  final String productId;
  final String productName;
  final String spec;
  final String unit;
  final int quantity;
  final double price;
  final double amount;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.spec,
    required this.unit,
    required this.quantity,
    required this.price,
  }) : amount = quantity * price;
}

class PurchaseOrder with HasId {
  @override final String id;
  final String supplierName;
  final DateTime orderDate;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String handler;

  PurchaseOrder({
    required this.id,
    required this.supplierName,
    required this.orderDate,
    required this.items,
    required this.handler,
    this.status = '待审核',
  }) : totalAmount = items.fold(0, (sum, item) => sum + item.amount);

  PurchaseOrder copyWith({
    String? id,
    String? supplierName,
    DateTime? orderDate,
    List<OrderItem>? items,
    String? status,
    String? handler,
  }) {
    return PurchaseOrder(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      orderDate: orderDate ?? this.orderDate,
      items: items ?? this.items,
      handler: handler ?? this.handler,
      status: status ?? this.status,
    );
  }
}

class SalesOrder with HasId {
  @override final String id;
  final String customerName;
  final DateTime orderDate;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String handler;

  SalesOrder({
    required this.id,
    required this.customerName,
    required this.orderDate,
    required this.items,
    required this.handler,
    this.status = '待审核',
  }) : totalAmount = items.fold(0, (sum, item) => sum + item.amount);

  SalesOrder copyWith({
    String? id,
    String? customerName,
    DateTime? orderDate,
    List<OrderItem>? items,
    String? status,
    String? handler,
  }) {
    return SalesOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      orderDate: orderDate ?? this.orderDate,
      items: items ?? this.items,
      handler: handler ?? this.handler,
      status: status ?? this.status,
    );
  }
}

class PurchaseReturn with HasId {
  @override final String id;
  final String supplierName;
  final String reason;
  final DateTime returnDate;
  final String status;
  final double amount;

  PurchaseReturn({
    required this.id,
    required this.supplierName,
    this.reason = '',
    required this.returnDate,
    this.status = '待处理',
    this.amount = 0,
  });

  PurchaseReturn copyWith({
    String? id,
    String? supplierName,
    String? reason,
    DateTime? returnDate,
    String? status,
    double? amount,
  }) {
    return PurchaseReturn(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      reason: reason ?? this.reason,
      returnDate: returnDate ?? this.returnDate,
      status: status ?? this.status,
      amount: amount ?? this.amount,
    );
  }
}

class SalesReturn with HasId {
  @override final String id;
  final String customerName;
  final String reason;
  final DateTime returnDate;
  final String status;
  final double amount;

  SalesReturn({
    required this.id,
    required this.customerName,
    this.reason = '',
    required this.returnDate,
    this.status = '待处理',
    this.amount = 0,
  });

  SalesReturn copyWith({
    String? id,
    String? customerName,
    String? reason,
    DateTime? returnDate,
    String? status,
    double? amount,
  }) {
    return SalesReturn(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      reason: reason ?? this.reason,
      returnDate: returnDate ?? this.returnDate,
      status: status ?? this.status,
      amount: amount ?? this.amount,
    );
  }
}

final List<String> orderStatusList = ['待审核', '已通过', '已完成', '已取消'];

final List<PurchaseOrder> mockPurchaseOrders = [
  PurchaseOrder(
    id: 'PO2025001', supplierName: '深圳华强电子有限公司',
    orderDate: DateTime(2025, 5, 6), handler: '张三', status: '已完成',
    items: [
      OrderItem(productId: 'P001', productName: '笔记本电脑', spec: 'ThinkPad X1', unit: '台', quantity: 10, price: 5800),
      OrderItem(productId: 'P002', productName: '无线鼠标', spec: 'Logitech M590', unit: '个', quantity: 50, price: 120),
    ],
  ),
  PurchaseOrder(
    id: 'PO2025002', supplierName: '广州办公用品批发',
    orderDate: DateTime(2025, 5, 8), handler: '张三', status: '已通过',
    items: [
      OrderItem(productId: 'P003', productName: 'A4打印纸', spec: '70g 500张/包', unit: '包', quantity: 100, price: 18),
      OrderItem(productId: 'P012', productName: '碎纸机', spec: 'A4 段状', unit: '台', quantity: 5, price: 280),
    ],
  ),
  PurchaseOrder(
    id: 'PO2025003', supplierName: '顺德家具厂',
    orderDate: DateTime(2025, 5, 10), handler: '张三', status: '待审核',
    items: [
      OrderItem(productId: 'P004', productName: '办公桌', spec: '1400x700mm', unit: '张', quantity: 10, price: 800),
      OrderItem(productId: 'P005', productName: '办公椅', spec: '人体工学', unit: '把', quantity: 20, price: 350),
    ],
  ),
  PurchaseOrder(
    id: 'PO2025004', supplierName: '农夫山泉代理',
    orderDate: DateTime(2025, 5, 11), handler: '张三', status: '已完成',
    items: [
      OrderItem(productId: 'P006', productName: '矿泉水', spec: '550ml 24瓶/箱', unit: '箱', quantity: 50, price: 22),
    ],
  ),
  PurchaseOrder(
    id: 'PO2025005', supplierName: '东莞五金工具厂',
    orderDate: DateTime(2025, 5, 12), handler: '张三', status: '已取消',
    items: [
      OrderItem(productId: 'P008', productName: '螺丝刀套装', spec: '12件套', unit: '套', quantity: 30, price: 45),
    ],
  ),
];

final List<SalesOrder> mockSalesOrders = [
  SalesOrder(
    id: 'SO2025001', customerName: '北京科技公司',
    orderDate: DateTime(2025, 5, 7), handler: '李四', status: '已完成',
    items: [
      OrderItem(productId: 'P001', productName: '笔记本电脑', spec: 'ThinkPad X1', unit: '台', quantity: 5, price: 6999),
      OrderItem(productId: 'P009', productName: '显示器', spec: '27寸 4K', unit: '台', quantity: 5, price: 2199),
    ],
  ),
  SalesOrder(
    id: 'SO2025002', customerName: '上海贸易商行',
    orderDate: DateTime(2025, 5, 9), handler: '李四', status: '已通过',
    items: [
      OrderItem(productId: 'P002', productName: '无线鼠标', spec: 'Logitech M590', unit: '个', quantity: 30, price: 199),
      OrderItem(productId: 'P011', productName: '键盘', spec: '机械键盘 青轴', unit: '个', quantity: 20, price: 349),
    ],
  ),
  SalesOrder(
    id: 'SO2025003', customerName: '广州零售店',
    orderDate: DateTime(2025, 5, 10), handler: '李四', status: '待审核',
    items: [
      OrderItem(productId: 'P007', productName: 'T恤', spec: '纯棉 M码', unit: '件', quantity: 50, price: 69),
    ],
  ),
  SalesOrder(
    id: 'SO2025004', customerName: '成都分销商',
    orderDate: DateTime(2025, 5, 11), handler: '李四', status: '已完成',
    items: [
      OrderItem(productId: 'P003', productName: 'A4打印纸', spec: '70g 500张/包', unit: '包', quantity: 200, price: 28),
      OrderItem(productId: 'P010', productName: '文件夹', spec: 'A4 蓝色', unit: '个', quantity: 300, price: 9.9),
    ],
  ),
  SalesOrder(
    id: 'SO2025005', customerName: '武汉采购中心',
    orderDate: DateTime(2025, 5, 12), handler: '孙七', status: '待审核',
    items: [
      OrderItem(productId: 'P004', productName: '办公桌', spec: '1400x700mm', unit: '张', quantity: 8, price: 1280),
      OrderItem(productId: 'P005', productName: '办公椅', spec: '人体工学', unit: '把', quantity: 16, price: 580),
    ],
  ),
];
