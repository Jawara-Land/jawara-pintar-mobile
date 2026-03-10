import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

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
          
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none,
                  color: AppColor.textTertiary,
                  size: 26,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColor.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '1',
                      style: AppTextStyle.caption.copyWith(
                        fontSize: 9,
                        color: AppColor.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
