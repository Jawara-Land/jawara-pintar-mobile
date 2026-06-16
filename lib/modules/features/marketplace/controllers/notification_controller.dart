import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:jawara_mobile/modules/features/marketplace/models/notification_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/repositories/marketplace_repository.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await MarketplaceRepository.getNotifications();
      if (response['success'] == true) {
        final List data = response['data']['notifications'] ?? [];
        notifications.value = data.map((e) => NotificationModel.fromJson(e)).toList();
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Gagal memuat notifikasi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final response = await MarketplaceRepository.getNotificationCount();
      if (response['success'] == true) {
        unreadCount.value = (response['data']['unread_count'] as num?)?.toInt() ?? 0;
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await MarketplaceRepository.markNotificationRead(notificationId);
      if (response['success'] == true) {
        final index = notifications.indexWhere((element) => element.id == notificationId);
        if (index != -1) {
          notifications[index] = NotificationModel(
            id: notifications[index].id,
            type: notifications[index].type,
            title: notifications[index].title,
            body: notifications[index].body,
            data: notifications[index].data,
            isRead: true,
            createdAt: notifications[index].createdAt,
          );
        }
        fetchUnreadCount();
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
    }
  }
}
