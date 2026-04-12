class HouseModel {
  final int id;
  final String address;

  HouseModel({
    required this.id,
    required this.address,
  });

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    return HouseModel(
      id: json['id'] as int,
      address: json['address'] as String,
    );
  }

  @override
  String toString() => 'HouseModel(id: $id, address: $address)';
}
