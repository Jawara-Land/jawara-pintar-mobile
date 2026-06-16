import 'package:jawara_mobile/modules/features/marketplace/models/product_model.dart';

class CartItemModel {
  final int id;
  final int productId;
  final int quantity;
  final ProductModel product;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
    );
  }
}
