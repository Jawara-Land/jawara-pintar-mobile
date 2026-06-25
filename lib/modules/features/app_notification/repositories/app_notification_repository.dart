import 'package:jawara_mobile/shared/utils/services/api_service.dart';
import '../constants/app_notification_api_constant.dart';

class AppNotificationRepository {
  static Future<Map<String, dynamic>> getNotifications() async {
    return await ApiService.get(AppNotificationApiConstant.appNotifications);
  }

  static Future<Map<String, dynamic>> getUnreadCount() async {
    return await ApiService.get(
      '${AppNotificationApiConstant.appNotifications}/unread-count',
    );
  }

  static Future<Map<String, dynamic>> markAsRead(int id) async {
    return await ApiService.put(
      '${AppNotificationApiConstant.appNotifications}/$id/read',
      {},
    );
  }

  static Future<Map<String, dynamic>> markAllAsRead() async {
    return await ApiService.put(
      '${AppNotificationApiConstant.appNotifications}/mark-all-read',
      {},
    );
  }
}
