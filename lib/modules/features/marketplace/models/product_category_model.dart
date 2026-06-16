class ProductCategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? icon;
  final bool isActive;
  final int sortOrder;

  ProductCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    required this.isActive,
    required this.sortOrder,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      icon: json['icon'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}
