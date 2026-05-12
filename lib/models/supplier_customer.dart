class Supplier {
  final String id;
  final String name;
  final String contact;
  final String phone;
  final String address;
  final String category;
  final bool enabled;

  Supplier({
    required this.id,
    required this.name,
    required this.contact,
    required this.phone,
    this.address = '',
    this.category = '',
    this.enabled = true,
  });

  Supplier copyWith({
    String? id,
    String? name,
    String? contact,
    String? phone,
    String? address,
    String? category,
    bool? enabled,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      category: category ?? this.category,
      enabled: enabled ?? this.enabled,
    );
  }
}

class Customer {
  final String id;
  final String name;
  final String contact;
  final String phone;
  final String address;
  final String level;
  final bool enabled;

  Customer({
    required this.id,
    required this.name,
    required this.contact,
    required this.phone,
    this.address = '',
    this.level = '普通',
    this.enabled = true,
  });

  Customer copyWith({
    String? id,
    String? name,
    String? contact,
    String? phone,
    String? address,
    String? level,
    bool? enabled,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      level: level ?? this.level,
      enabled: enabled ?? this.enabled,
    );
  }
}

final List<Supplier> mockSuppliers = [
  Supplier(id: 'S001', name: '深圳华强电子有限公司', contact: '刘先生', phone: '0755-12345678', address: '深圳市华强北路', category: '电子产品'),
  Supplier(id: 'S002', name: '广州办公用品批发', contact: '陈女士', phone: '020-87654321', address: '广州市天河区', category: '办公用品'),
  Supplier(id: 'S003', name: '顺德家具厂', contact: '黄经理', phone: '0757-11112222', address: '佛山市顺德区', category: '家具'),
  Supplier(id: 'S004', name: '农夫山泉代理', contact: '周先生', phone: '0571-88889999', address: '杭州市西湖区', category: '食品饮料'),
  Supplier(id: 'S005', name: '泉州服装有限公司', contact: '林女士', phone: '0595-33334444', address: '泉州市晋江', category: '服装鞋帽'),
  Supplier(id: 'S006', name: '东莞五金工具厂', contact: '张先生', phone: '0769-55556666', address: '东莞市长安镇', category: '五金配件'),
];

final List<Customer> mockCustomers = [
  Customer(id: 'C001', name: '北京科技公司', contact: '王经理', phone: '010-12345678', address: '北京市海淀区', level: 'VIP'),
  Customer(id: 'C002', name: '上海贸易商行', contact: '李总', phone: '021-87654321', address: '上海市浦东新区', level: '普通'),
  Customer(id: 'C003', name: '广州零售店', contact: '赵先生', phone: '020-11112222', address: '广州市越秀区', level: '普通'),
  Customer(id: 'C004', name: '成都分销商', contact: '刘女士', phone: '028-88889999', address: '成都市高新区', level: 'VIP'),
  Customer(id: 'C005', name: '武汉采购中心', contact: '陈经理', phone: '027-33334444', address: '武汉市洪山区', level: '普通'),
];
