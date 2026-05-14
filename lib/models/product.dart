class Product {
  final String id;
  final String sku;
  final String name;
  final String category;
  final String spec;
  final String unit;
  final double purchasePrice;
  final double salePrice;
  final int stock;
  final String supplierName;

  Product({
    required this.id,
    this.sku = '',
    required this.name,
    required this.category,
    required this.spec,
    required this.unit,
    required this.purchasePrice,
    required this.salePrice,
    this.stock = 0,
    this.supplierName = '',
  });

  Product copyWith({
    String? id,
    String? sku,
    String? name,
    String? category,
    String? spec,
    String? unit,
    double? purchasePrice,
    double? salePrice,
    int? stock,
    String? supplierName,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      category: category ?? this.category,
      spec: spec ?? this.spec,
      unit: unit ?? this.unit,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      stock: stock ?? this.stock,
      supplierName: supplierName ?? this.supplierName,
    );
  }
}

final List<String> categoryOptions = [
  '电子产品', '办公用品', '家具', '食品饮料', '服装鞋帽',
  '五金配件', '化工原料', '包装材料', '工具', '其他',
];

final List<Product> mockProducts = [
  Product(id: 'P001', sku: 'NB-ThinkPad-X1', name: '笔记本电脑', category: '电子产品', spec: 'ThinkPad X1', unit: '台', purchasePrice: 5800, salePrice: 6999, stock: 50, supplierName: '深圳华强电子有限公司'),
  Product(id: 'P002', sku: 'MS-Logi-M590', name: '无线鼠标', category: '电子产品', spec: 'Logitech M590', unit: '个', purchasePrice: 120, salePrice: 199, stock: 200, supplierName: '深圳华强电子有限公司'),
  Product(id: 'P003', sku: 'PP-A4-70g', name: 'A4打印纸', category: '办公用品', spec: '70g 500张/包', unit: '包', purchasePrice: 18, salePrice: 28, stock: 500, supplierName: '广州办公用品批发'),
  Product(id: 'P004', sku: 'DESK-1400', name: '办公桌', category: '家具', spec: '1400x700mm', unit: '张', purchasePrice: 800, salePrice: 1280, stock: 30, supplierName: '顺德家具厂'),
  Product(id: 'P005', sku: 'CHAIR-EGRO', name: '办公椅', category: '家具', spec: '人体工学', unit: '把', purchasePrice: 350, salePrice: 580, stock: 60, supplierName: '顺德家具厂'),
  Product(id: 'P006', sku: 'WATER-550ml', name: '矿泉水', category: '食品饮料', spec: '550ml 24瓶/箱', unit: '箱', purchasePrice: 22, salePrice: 36, stock: 300, supplierName: '农夫山泉代理'),
  Product(id: 'P007', sku: 'TSHIRT-COTTON-M', name: 'T恤', category: '服装鞋帽', spec: '纯棉 M码', unit: '件', purchasePrice: 35, salePrice: 69, stock: 150, supplierName: '泉州服装有限公司'),
  Product(id: 'P008', sku: 'TOOL-SCREW-12', name: '螺丝刀套装', category: '工具', spec: '12件套', unit: '套', purchasePrice: 45, salePrice: 85, stock: 80, supplierName: '东莞五金工具厂'),
  Product(id: 'P009', sku: 'MON-27-4K', name: '显示器', category: '电子产品', spec: '27寸 4K', unit: '台', purchasePrice: 1500, salePrice: 2199, stock: 40, supplierName: '深圳华强电子有限公司'),
  Product(id: 'P010', sku: 'FOLDER-A4-BLUE', name: '文件夹', category: '办公用品', spec: 'A4 蓝色', unit: '个', purchasePrice: 5, salePrice: 9.9, stock: 1000, supplierName: '广州办公用品批发'),
  Product(id: 'P011', sku: 'KB-MECH-BLUE', name: '键盘', category: '电子产品', spec: '机械键盘 青轴', unit: '个', purchasePrice: 200, salePrice: 349, stock: 75, supplierName: '深圳华强电子有限公司'),
  Product(id: 'P012', sku: 'SHREDDER-A4', name: '碎纸机', category: '办公用品', spec: 'A4 段状', unit: '台', purchasePrice: 280, salePrice: 450, stock: 25, supplierName: '广州办公用品批发'),
];
