import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/marketplace/controllers/notification_controller.dart';
import 'package:intl/intl.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class NotificationListScreen extends GetView<NotificationController> {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi Marketplace')),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const AppEmptyState(icon: Icons.notifications_none, message: 'Belum ada notifikasi');
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchNotifications();
            await controller.fetchUnreadCount();
          },
          child: ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notif = controller.notifications[index];
              return Container(
                color: notif.isRead
                    ? AppColor.transparent
                    : AppColor.notificationUnread.withOpacity(0.05),
                child: ListTile(
                  title: Text(
                    notif.title,
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontWeight: notif.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(notif.body),
                      const SizedBox(height: 4),
                      if (notif.createdAt != null)
                        Text(
                          DateFormat(
                            'dd MMM yyyy HH:mm',
                          ).format(notif.createdAt!),
                          style: AppTextStyle.caption.copyWith(fontSize: 10),
                        ),
                    ],
                  ),
                  leading: Icon(
                    Icons.notifications,
                    color: notif.isRead ? AppColor.textTertiary : AppColor.primary,
                  ),
                  onTap: () {
                    if (!notif.isRead) {
                      controller.markAsRead(notif.id);
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
