import 'package:jawara_mobile/modules/features/marketplace/constants/marketplace_api_constant.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

class AddressRepository {
  static Future<Map<String, dynamic>> getAddresses() async {
    return await ApiService.get(MarketplaceApiConstant.addresses);
  }

  static Future<Map<String, dynamic>> createAddress({
    required String address,
    String? label,
    String? phone,
    bool? isPrimary,
  }) async {
    return await ApiService.post(MarketplaceApiConstant.addresses, {
      'address': address,
      if (label != null) 'label': label,
      if (phone != null) 'phone': phone,
      if (isPrimary != null) 'is_primary': isPrimary ? 1 : 0,
    });
  }

  static Future<Map<String, dynamic>> updateAddress(
    int id, {
    required String address,
    String? label,
    String? phone,
    bool? isPrimary,
  }) async {
    return await ApiService.put('${MarketplaceApiConstant.addresses}/$id', {
      'address': address,
      if (label != null) 'label': label,
      if (phone != null) 'phone': phone,
      if (isPrimary != null) 'is_primary': isPrimary ? 1 : 0,
    });
  }

  static Future<Map<String, dynamic>> deleteAddress(int id) async {
    return await ApiService.delete('${MarketplaceApiConstant.addresses}/$id');
  }

  static Future<Map<String, dynamic>> setPrimaryAddress(int id) async {
    return await ApiService.put(
      '${MarketplaceApiConstant.addresses}/$id/primary',
      {},
    );
  }
}
