import 'package:jawara_mobile/modules/features/marketplace/constants/marketplace_api_constant.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

class OrderRepository {
  static Future<Map<String, dynamic>> checkout({
    required String deliveryMethod,
    required List<int> cartItemIds,
    int? addressId,
    String? notes,
    int? shippingCost,
  }) async {
    return await ApiService.post(MarketplaceApiConstant.orders, {
      'delivery_method': deliveryMethod,
      if (addressId != null) 'address_id': addressId,
      'cart_item_ids': cartItemIds,
      if (notes != null) 'notes': notes,
      if (shippingCost != null) 'shipping_cost': shippingCost,
    });
  }

  static Future<Map<String, dynamic>> getOrders({
    int page = 1,
    String? status,
  }) async {
    String query = '?page=$page';
    if (status != null && status.isNotEmpty) query += '&status=$status';
    return await ApiService.get('${MarketplaceApiConstant.orders}$query');
  }

  static Future<Map<String, dynamic>> getSellerOrders({
    int page = 1,
    String? status,
  }) async {
    String query = '?page=$page';
    if (status != null && status.isNotEmpty) query += '&status=$status';
    return await ApiService.get('${MarketplaceApiConstant.sellerOrders}$query');
  }

  static Future<Map<String, dynamic>> getOrderDetail(int id) async {
    return await ApiService.get('${MarketplaceApiConstant.orders}/$id');
  }

  static Future<Map<String, dynamic>> getPayment(int orderId) async {
    return await ApiService.get(
      '${MarketplaceApiConstant.orders.replaceFirst('/orders', '/payment')}/$orderId',
    );
  }

  static Future<Map<String, dynamic>> updateOrderStatus(
    int orderId,
    String status, {
    String? cancelReason,
  }) async {
    return await ApiService.put(
      '${MarketplaceApiConstant.orders}/$orderId/status',
      {
        'status': status,
        if (cancelReason != null) 'cancel_reason': cancelReason,
      },
    );
  }
}
