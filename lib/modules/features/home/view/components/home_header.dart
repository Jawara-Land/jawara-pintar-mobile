import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';
import 'package:jawara_mobile/modules/features/app_notification/controllers/app_notification_controller.dart';
import 'package:jawara_mobile/configs/routes/route.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: AppColor.primaryLight,
            child: Icon(Icons.person, color: AppColor.primary, size: 28),
          ),

          SizedBox(width: 12),

          Obx(() {
            final user = AuthController.to.currentUser.value;
            final name = user?.name ?? 'User';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo',
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.textTertiary,
                    fontSize: 13,
                  ),
                ),
                Text(name, style: AppTextStyle.titleLarge),
              ],
            );
          }),

          Spacer(),

          Obx(() {
            final unreadCount =
                Get.find<AppNotificationController>().unreadCount.value;
            return BadgeCount(
              count: unreadCount,
              size: 16,
              fontSize: 10,
              borderRadius: 99,
              child: IconButton(
                onPressed: () {
                  Get.toNamed(Routes.appNotificationRoute);
                },
                icon: Icon(
                  Icons.notifications_none,
                  color: AppColor.textTertiary,
                  size: 26,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
