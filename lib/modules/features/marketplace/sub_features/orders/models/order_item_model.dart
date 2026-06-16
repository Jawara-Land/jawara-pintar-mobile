import 'package:jawara_mobile/modules/features/marketplace/models/product_model.dart';

class OrderItemModel {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final int priceAtPurchase;
  final int subtotal;
  final ProductModel? product;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceAtPurchase,
    required this.subtotal,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      productId: (json['product_id'] as num?)?.toInt() ?? 0,
      productName: json['product_name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      priceAtPurchase: (json['price_at_purchase'] as num?)?.toInt() ?? (json['price'] as num?)?.toInt() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toInt() ?? 0,
      product: json['product'] != null && json['product'] is Map ? ProductModel.fromJson(json['product']) : null,
    );
  }
}
