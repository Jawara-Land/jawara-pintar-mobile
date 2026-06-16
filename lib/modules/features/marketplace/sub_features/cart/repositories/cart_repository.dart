import 'package:jawara_mobile/modules/features/marketplace/constants/marketplace_api_constant.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

class CartRepository {
  static Future<Map<String, dynamic>> getCart() async {
    return await ApiService.get(MarketplaceApiConstant.cart);
  }

  static Future<Map<String, dynamic>> addToCart(
    int productId,
    int quantity,
  ) async {
    return await ApiService.post(MarketplaceApiConstant.cart, {
      'product_id': productId,
      'quantity': quantity,
    });
  }

  static Future<Map<String, dynamic>> updateCartItem(
    int cartId,
    int quantity,
  ) async {
    return await ApiService.put('${MarketplaceApiConstant.cart}/$cartId', {
      'quantity': quantity,
    });
  }

  static Future<Map<String, dynamic>> deleteCartItem(int cartId) async {
    return await ApiService.delete('${MarketplaceApiConstant.cart}/$cartId');
  }
}
