class HouseModel {
  final int id;
  final String address;
  final String status;

  HouseModel({
    required this.id,
    required this.address,
    required this.status,
  });

  bool get isOccupied => status == 'occupied';
  bool get isAvailable => status == 'available';

  String get statusLabel {
    switch (status) {
      case 'available':
        return 'Tersedia';
      case 'occupied':
        return 'Ditempati';
      case 'inactive':
        return 'Nonaktif';
      default:
        return status;
    }
  }

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    return HouseModel(
      id: json['id'] as int,
      address: json['address'] as String? ?? '',
      status: json['status'] as String? ?? 'available',
    );
  }
}
