class IncomeCategoryModel {
  final int id;
  final String name;

  IncomeCategoryModel({required this.id, required this.name});

  factory IncomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return IncomeCategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}
