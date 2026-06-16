import 'package:jawara_mobile/modules/features/login/models/user_model.dart';

class StoreModel {
  final int id;
  final int userId;
  final String name;
  final String? description;
  final String? address;
  final String? phone;
  final int shippingCost;
  final bool isActive;
  final int? totalProducts;
  final String? ownerName;
  final String? imageUrl;
  final DateTime? createdAt;
  final UserModel? user;

  StoreModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.address,
    this.phone,
    required this.shippingCost,
    required this.isActive,
    this.totalProducts,
    this.ownerName,
    this.imageUrl,
    this.createdAt,
    this.user,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: _toInt(json['id']) ?? 0,
      userId: _toInt(json['user_id']) ?? 0,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      shippingCost: _toInt(json['shipping_cost']) ?? _toInt(json['default_shipping_cost']) ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      totalProducts: _toInt(json['total_products']),
      ownerName: json['owner_name'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'shipping_cost': shippingCost,
      'is_active': isActive,
      'image_url': imageUrl,
    };
  }
}
