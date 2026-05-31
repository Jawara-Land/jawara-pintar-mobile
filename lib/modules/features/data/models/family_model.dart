class FamilyModel {
  final int id;
  final String name;
  final bool isActive;
  final String? headOfFamilyName;
  final String? currentHouseAddress;
  final int? currentHouseId;

  FamilyModel({
    required this.id,
    required this.name,
    this.isActive = true,
    this.headOfFamilyName,
    this.currentHouseAddress,
    this.currentHouseId,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      headOfFamilyName: json['head_of_family_name'] as String?,
      currentHouseAddress: json['current_house_address'] as String?,
      currentHouseId: json['current_house_id'] as int?,
    );
  }
}
