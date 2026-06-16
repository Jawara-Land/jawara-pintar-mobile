import 'package:jawara_mobile/modules/features/login/models/user_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/models/order_item_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/models/marketplace_payment_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/models/address_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/models/store_model.dart';

class OrderModel {
  final int id;
  final String orderNumber;
  final int buyerId;
  final int storeId;
  final int? addressId;
  final int subtotal;
  final int shippingCost;
  final int serviceFee;
  final int totalAmount;
  final String status;
  final String statusLabel;
  final String deliveryMethod;
  final String? midtransSnapToken;
  final String? midtransRedirectUrl;
  final String? notes;
  final String? shippingAddress;
  final String? buyerName;
  final String? storeName;
  final int? itemsCount;
  final List<OrderItemModel>? items;
  final AddressModel? address;
  final MarketplacePaymentModel? payment;
  final String? cancelledBy;
  final String? cancelReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final StoreModel? store;
  final UserModel? buyer;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.buyerId,
    required this.storeId,
    this.addressId,
    required this.subtotal,
    required this.shippingCost,
    required this.serviceFee,
    required this.totalAmount,
    required this.status,
    required this.statusLabel,
    required this.deliveryMethod,
    this.midtransSnapToken,
    this.midtransRedirectUrl,
    this.notes,
    this.shippingAddress,
    this.buyerName,
    this.storeName,
    this.itemsCount,
    this.items,
    this.address,
    this.payment,
    this.cancelledBy,
    this.cancelReason,
    this.createdAt,
    this.updatedAt,
    this.store,
    this.buyer,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    int calculatedSubtotal = 0;
    if (json['items'] != null && json['items'] is List) {
      for (var item in json['items']) {
        final price = (item['price'] as num?)?.toInt() ?? 0;
        final qty = (item['quantity'] as num?)?.toInt() ?? 0;
        calculatedSubtotal += (price * qty);
      }
    } else {
      calculatedSubtotal = (json['subtotal'] as num?)?.toInt() ?? 0;
    }

    return OrderModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      orderNumber: json['order_number'] as String? ?? '',
      buyerId: (json['buyer_id'] as num?)?.toInt() ?? 0,
      storeId: (json['store_id'] as num?)?.toInt() ?? 0,
      addressId: (json['address_id'] as num?)?.toInt(),
      subtotal: calculatedSubtotal,
      shippingCost: (json['shipping_cost'] as num?)?.toInt() ?? 0,
      serviceFee: (json['service_fee'] as num?)?.toInt() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'pending',
      statusLabel: json['status_label'] as String? ?? '',
      deliveryMethod: json['delivery_method'] as String? ?? 'pickup',
      midtransSnapToken: json['midtrans_snap_token'] as String?,
      midtransRedirectUrl: json['midtrans_redirect_url'] as String?,
      notes: json['notes'] as String?,
      shippingAddress: json['shipping_address'] as String?,
      buyerName: json['buyer_name'] as String?,
      storeName: json['store_name'] as String?,
      itemsCount: (json['items_count'] as num?)?.toInt(),
      items: json['items'] != null && json['items'] is List
          ? (json['items'] as List)
                .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
                .toList()
          : null,
      address: json['address'] != null && json['address'] is Map
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      payment: json['payment'] != null && json['payment'] is Map
          ? MarketplacePaymentModel.fromJson(
              json['payment'] as Map<String, dynamic>,
            )
          : null,
      cancelledBy: json['cancelled_by'] as String?,
      cancelReason: json['cancel_reason'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      store: json['store'] != null && json['store'] is Map
          ? StoreModel.fromJson(json['store'])
          : null,
      buyer: json['buyer'] != null && json['buyer'] is Map
          ? UserModel.fromJson(json['buyer'])
          : null,
    );
  }
}
