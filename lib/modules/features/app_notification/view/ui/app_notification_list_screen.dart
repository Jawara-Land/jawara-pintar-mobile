import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import '../../controllers/app_notification_controller.dart';
import '../../models/app_notification_model.dart';

class AppNotificationListScreen extends GetView<AppNotificationController> {
  const AppNotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppNotificationController>()) {
      Get.lazyPut(() => AppNotificationController());
    }

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: AppTextStyle.headingSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(
            () => controller.unreadCount.value > 0
                ? TextButton(
                    onPressed: controller.markAllAsRead,
                    child: Text(
                      'Tandai baca',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _buildNotificationItem(notification);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 64,
            color: AppColor.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Notifikasi',
            style: AppTextStyle.titleLarge.copyWith(
              color: AppColor.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifikasi Anda akan muncul di sini',
            style: AppTextStyle.bodyMedium.copyWith(color: AppColor.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(AppNotificationModel notification) {
    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          controller.markAsRead(notification.id);
        }
      },
      child: Container(
        color: notification.isRead
            ? Colors.transparent
            : AppColor.primaryLight.withOpacity(0.3),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications,
                color: AppColor.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyle.titleMedium.copyWith(
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        notification.formattedDate,
                        style: AppTextStyle.caption.copyWith(
                          color: AppColor.textHint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: notification.isRead
                          ? AppColor.textSecondary
                          : AppColor.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead) ...[
              const SizedBox(width: 12),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: AppColor.error,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
