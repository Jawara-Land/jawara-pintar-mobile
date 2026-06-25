import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../models/app_notification_model.dart';
import '../repositories/app_notification_repository.dart';

class AppNotificationController extends GetxController {
  final RxList<AppNotificationModel> notifications =
      <AppNotificationModel>[].obs;
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
      final response = await AppNotificationRepository.getNotifications();
      if (response['success'] == true) {
        final List data = response['data']['notifications'] ?? [];
        notifications.value = data
            .map((e) => AppNotificationModel.fromJson(e))
            .toList();
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
      final response = await AppNotificationRepository.getUnreadCount();
      if (response['success'] == true) {
        unreadCount.value =
            (response['data']['unread_count'] as num?)?.toInt() ?? 0;
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await AppNotificationRepository.markAsRead(
        notificationId,
      );
      if (response['success'] == true) {
        final index = notifications.indexWhere(
          (element) => element.id == notificationId,
        );
        if (index != -1) {
          notifications[index] = AppNotificationModel(
            id: notifications[index].id,
            type: notifications[index].type,
            title: notifications[index].title,
            body: notifications[index].body,
            data: notifications[index].data,
            isRead: true,
            createdAt: notifications[index].createdAt,
            formattedDate: notifications[index].formattedDate,
          );
        }
        fetchUnreadCount();
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await AppNotificationRepository.markAllAsRead();
      if (response['success'] == true) {
        final updatedList = notifications
            .map(
              (element) => AppNotificationModel(
                id: element.id,
                type: element.type,
                title: element.title,
                body: element.body,
                data: element.data,
                isRead: true,
                createdAt: element.createdAt,
                formattedDate: element.formattedDate,
              ),
            )
            .toList();
        notifications.assignAll(updatedList);
        unreadCount.value = 0;
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
    }
  }
}
