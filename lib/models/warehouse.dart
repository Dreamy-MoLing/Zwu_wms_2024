import 'interfaces.dart';

class Warehouse with HasId, HasEnabled {
  @override final String id;
  final String name;
  final String contact;
  final String phone;
  final String address;
  @override final bool enabled;

  Warehouse({
    required this.id,
    required this.name,
    this.contact = '',
    this.phone = '',
    this.address = '',
    this.enabled = true,
  });

  Warehouse copyWith({
    String? id,
    String? name,
    String? contact,
    String? phone,
    String? address,
    bool? enabled,
  }) {
    return Warehouse(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      enabled: enabled ?? this.enabled,
    );
  }
}

final List<Warehouse> mockWarehouses = [
  Warehouse(id: 'WH001', name: '主仓库', contact: '王五', phone: '13800000004', address: '公司总部一楼'),
  Warehouse(id: 'WH002', name: '电子品专用仓', contact: '周仓管', phone: '13800000101', address: '公司总部二楼'),
  Warehouse(id: 'WH003', name: '华南分仓', contact: '林主管', phone: '13800000102', address: '广州市白云区'),
];
