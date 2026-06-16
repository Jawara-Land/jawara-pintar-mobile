import 'dart:io';
import 'package:jawara_mobile/modules/features/marketplace/constants/marketplace_api_constant.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

class StoreRepository {
  static Future<Map<String, dynamic>> getMyStore() async {
    return await ApiService.get(MarketplaceApiConstant.myStore);
  }

  static Future<Map<String, dynamic>> getStoreDashboard() async {
    return await ApiService.get(MarketplaceApiConstant.storeDashboard);
  }

  static Future<Map<String, dynamic>> getSellerOrders({int limit = 5}) async {
    return await ApiService.get(
      '${MarketplaceApiConstant.sellerOrders}?limit=$limit',
    );
  }

  static Future<Map<String, dynamic>> createStore({
    required String name,
    String? description,
    String? address,
    String? phone,
    int? shippingCost,
    File? image,
  }) async {
    final fields = {
      'name': name,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (shippingCost != null) 'shipping_cost': shippingCost.toString(),
    };

    final files = <String, File>{};
    if (image != null) files['image'] = image;

    if (image != null) {
      return await ApiService.postMultipart(
        MarketplaceApiConstant.stores,
        fields: fields,
        files: files,
      );
    } else {
      return await ApiService.post(MarketplaceApiConstant.stores, fields);
    }
  }

  static Future<Map<String, dynamic>> updateStore({
    required String name,
    String? description,
    String? address,
    String? phone,
    int? shippingCost,
    File? image,
  }) async {
    final fields = {
      '_method': 'POST',
      'name': name,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (shippingCost != null) 'shipping_cost': shippingCost.toString(),
    };

    final files = <String, File>{};
    if (image != null) files['image'] = image;

    if (image != null) {
      return await ApiService.postMultipart(
        MarketplaceApiConstant.myStore,
        fields: fields,
        files: files,
      );
    } else {
      return await ApiService.post(MarketplaceApiConstant.myStore, {
        ...fields,
        '_method': 'PUT',
      });
    }
  }

  static Future<Map<String, dynamic>> getMyProducts({int page = 1}) async {
    return await ApiService.get(
      '${MarketplaceApiConstant.myProducts}?page=$page',
    );
  }

  static Future<Map<String, dynamic>> createProduct({
    required String name,
    String? description,
    required int price,
    required int stock,
    required int categoryId,
    File? image,
    required String type,
    int? weight,
    String? duration,
    String? tnc,
    String? location,
  }) async {
    final fields = {
      'name': name,
      'price': price.toString(),
      'stock': stock.toString(),
      'category_id': categoryId.toString(),
      'type': type,
      if (description != null) 'description': description,
      if (weight != null) 'weight': weight.toString(),
      if (duration != null) 'duration': duration,
      if (tnc != null) 'tnc': tnc,
      if (location != null) 'location': location,
    };

    final files = <String, File>{};
    if (image != null) files['image'] = image;

    return await ApiService.postMultipart(
      MarketplaceApiConstant.products,
      fields: fields,
      files: files,
    );
  }

  static Future<Map<String, dynamic>> updateProduct(
    int id, {
    String? name,
    String? description,
    int? price,
    int? stock,
    int? categoryId,
    File? image,
    String? type,
    int? weight,
    String? duration,
    String? tnc,
    String? location,
    bool? isActive,
  }) async {
    final fields = {
      '_method': 'PUT',
      if (name != null) 'name': name,
      if (price != null) 'price': price.toString(),
      if (stock != null) 'stock': stock.toString(),
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId.toString(),
      if (type != null) 'type': type,
      if (weight != null) 'weight': weight.toString(),
      if (duration != null) 'duration': duration,
      if (tnc != null) 'tnc': tnc,
      if (location != null) 'location': location,
      if (isActive != null) 'is_active': isActive ? '1' : '0',
    };

    final files = <String, File>{};
    if (image != null) files['image'] = image;

    return await ApiService.postMultipart(
      '${MarketplaceApiConstant.products}/$id',
      fields: fields,
      files: files,
    );
  }

  static Future<Map<String, dynamic>> deleteProduct(int id) async {
    return await ApiService.delete('${MarketplaceApiConstant.products}/$id');
  }
}
