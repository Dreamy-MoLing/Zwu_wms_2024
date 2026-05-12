class Product {
  final String id;
  final String name;
  final String category;
  final String spec;
  final String unit;
  final double purchasePrice;
  final double salePrice;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.spec,
    required this.unit,
    required this.purchasePrice,
    required this.salePrice,
    this.stock = 0,
  });

  Product copyWith({
    String? id,
    String? name,
    String? category,
    String? spec,
    String? unit,
    double? purchasePrice,
    double? salePrice,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      spec: spec ?? this.spec,
      unit: unit ?? this.unit,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      stock: stock ?? this.stock,
    );
  }
}

final List<String> categoryOptions = [
  '电子产品', '办公用品', '家具', '食品饮料', '服装鞋帽',
  '五金配件', '化工原料', '包装材料', '工具', '其他',
];

final List<Product> mockProducts = [
  Product(id: 'P001', name: '笔记本电脑', category: '电子产品', spec: 'ThinkPad X1', unit: '台', purchasePrice: 5800, salePrice: 6999, stock: 50),
  Product(id: 'P002', name: '无线鼠标', category: '电子产品', spec: 'Logitech M590', unit: '个', purchasePrice: 120, salePrice: 199, stock: 200),
  Product(id: 'P003', name: 'A4打印纸', category: '办公用品', spec: '70g 500张/包', unit: '包', purchasePrice: 18, salePrice: 28, stock: 500),
  Product(id: 'P004', name: '办公桌', category: '家具', spec: '1400x700mm', unit: '张', purchasePrice: 800, salePrice: 1280, stock: 30),
  Product(id: 'P005', name: '办公椅', category: '家具', spec: '人体工学', unit: '把', purchasePrice: 350, salePrice: 580, stock: 60),
  Product(id: 'P006', name: '矿泉水', category: '食品饮料', spec: '550ml 24瓶/箱', unit: '箱', purchasePrice: 22, salePrice: 36, stock: 300),
  Product(id: 'P007', name: 'T恤', category: '服装鞋帽', spec: '纯棉 M码', unit: '件', purchasePrice: 35, salePrice: 69, stock: 150),
  Product(id: 'P008', name: '螺丝刀套装', category: '工具', spec: '12件套', unit: '套', purchasePrice: 45, salePrice: 85, stock: 80),
  Product(id: 'P009', name: '显示器', category: '电子产品', spec: '27寸 4K', unit: '台', purchasePrice: 1500, salePrice: 2199, stock: 40),
  Product(id: 'P010', name: '文件夹', category: '办公用品', spec: 'A4 蓝色', unit: '个', purchasePrice: 5, salePrice: 9.9, stock: 1000),
  Product(id: 'P011', name: '键盘', category: '电子产品', spec: '机械键盘 青轴', unit: '个', purchasePrice: 200, salePrice: 349, stock: 75),
  Product(id: 'P012', name: '碎纸机', category: '办公用品', spec: 'A4 段状', unit: '台', purchasePrice: 280, salePrice: 450, stock: 25),
];
