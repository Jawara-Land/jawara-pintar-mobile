import 'package:jawara_mobile/modules/features/marketplace/constants/marketplace_api_constant.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

class MarketplaceRepository {

  // Categories
  static Future<Map<String, dynamic>> getCategories() async {
    return await ApiService.get(MarketplaceApiConstant.categories);
  }

  // Products 
  static Future<Map<String, dynamic>> getProducts({
    int page = 1,
    String? search,
    int? categoryId,
  }) async {
    String query = '?page=$page';
    if (search != null && search.isNotEmpty) query += '&filter[name]=$search';
    if (categoryId != null) query += '&filter[category_id]=$categoryId';
    return await ApiService.get('${MarketplaceApiConstant.products}$query');
  }

  static Future<Map<String, dynamic>> getProductDetail(int id) async {
    return await ApiService.get('${MarketplaceApiConstant.products}/$id');
  }

  // Notifications
  static Future<Map<String, dynamic>> getNotifications() async {
    return await ApiService.get(MarketplaceApiConstant.notifications);
  }

  static Future<Map<String, dynamic>> getNotificationCount() async {
    return await ApiService.get(
      '${MarketplaceApiConstant.notifications}/count',
    );
  }

  static Future<Map<String, dynamic>> getNotificationDetail(int id) async {
    return await ApiService.get('${MarketplaceApiConstant.notifications}/$id');
  }

  static Future<Map<String, dynamic>> markNotificationRead(int id) async {
    return await ApiService.put(
      '${MarketplaceApiConstant.notifications}/$id/read',
      {},
    );
  }

  // Settings
  static Future<Map<String, dynamic>> getSettings() async {
    return await ApiService.get(MarketplaceApiConstant.settings);
  }
}
