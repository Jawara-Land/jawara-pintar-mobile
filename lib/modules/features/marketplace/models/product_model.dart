import 'package:jawara_mobile/modules/features/marketplace/models/product_category_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/models/store_model.dart';

class ProductModel {
  final int id;
  final int storeId;
  final int? categoryId;
  final String name;
  final String? description;
  final int price;
  final int stock;
  final String? imageUrl;
  final int? weight;
  final int? shippingCost;
  final bool isActive;
  final String? storeName;
  final String? storeImageUrl;
  final String? sellerName;
  final String? categoryName;
  final int? storeDefaultShipping;
  final String type; // 'goods' or 'service'
  final String? duration;
  final String? tnc;
  final String? location;
  final DateTime? createdAt;
  final StoreModel? store;
  final ProductCategoryModel? category;

  ProductModel({
    required this.id,
    required this.storeId,
    this.categoryId,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.weight,
    this.shippingCost,
    required this.isActive,
    this.storeName,
    this.storeImageUrl,
    this.sellerName,
    this.categoryName,
    this.storeDefaultShipping,
    required this.type,
    this.duration,
    this.tnc,
    this.location,
    this.createdAt,
    this.store,
    this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      storeId: json['store_id'] as int,
      categoryId: json['category_id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'] as int,
      stock: json['stock'] as int,
      imageUrl: json['image_url'] as String?,
      weight: json['weight'] as int?,
      shippingCost: json['shipping_cost'] as int?,
      isActive: json['is_active'] as bool? ?? true,
      storeName: json['store_name'] as String?,
      storeImageUrl: json['store_image_url'] as String?,
      sellerName: json['seller_name'] as String?,
      categoryName: json['category_name'] as String?,
      storeDefaultShipping: (json['store_shipping_cost'] as num?)?.toInt() ?? (json['store_default_shipping'] as num?)?.toInt(),
      type: json['type'] as String? ?? 'goods',
      duration: json['duration'] as String?,
      tnc: json['tnc'] as String?,
      location: json['location'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      store: json['store'] != null ? StoreModel.fromJson(json['store']) : null,
      category: json['category'] != null ? ProductCategoryModel.fromJson(json['category']) : null,
    );
  }
}
