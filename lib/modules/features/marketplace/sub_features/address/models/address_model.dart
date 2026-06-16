class AddressModel {
  final int id;
  final String? label;
  final String address;
  final String? phone;
  final bool isPrimary;

  AddressModel({
    required this.id,
    this.label,
    required this.address,
    this.phone,
    required this.isPrimary,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int,
      label: json['label'] as String?,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      isPrimary: (json['is_primary'] == 1 || json['is_primary'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'address': address,
      'phone': phone,
      'is_primary': isPrimary,
    };
  }
}
