import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import '../../controllers/announcement_controller.dart';

class AnnouncementScreen extends GetView<AnnouncementController> {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'Pengumuman',
          style: AppTextStyle.headingSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColor.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        final user = AuthController.to.currentUser.value;
        final canCreate =
            user?.roles.any((r) => ['admin', 'community_head'].contains(r)) ??
            false;
        return canCreate
            ? FloatingActionButton(
                backgroundColor: AppColor.primary,
                child: const Icon(Icons.add, color: AppColor.textOnPrimary),
                onPressed: () => Get.toNamed(Routes.announcementFormRoute),
              )
            : const SizedBox.shrink();
      }),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.announcements.isEmpty) {
          return const Center(child: Text('Tidak ada pengumuman tersedia.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.announcements.length,
          itemBuilder: (context, index) {
            final announcement = controller.announcements[index];
            return _buildAnnouncementCard(
              date: announcement.published,
              title: announcement.title,
              category: 'Pengumuman',
              organizer: announcement.creator,
            );
          },
        );
      }),
    );
  }

  Widget _buildAnnouncementCard({
    required String date,
    required String title,
    required String category,
    required String organizer,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColor.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(date, style: AppTextStyle.bodySmall),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          SizedBox(height: 8),

          Text(title, style: AppTextStyle.titleLarge),

          SizedBox(height: 12),

          Row(
            children: [
              Icon(Icons.groups, size: 20, color: AppColor.textSecondary),

              SizedBox(width: 8),

              Expanded(child: Text(category, style: AppTextStyle.bodySmall)),
            ],
          ),

          SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.person, size: 20, color: AppColor.textSecondary),

              SizedBox(width: 8),

              Expanded(child: Text(organizer, style: AppTextStyle.bodySmall)),
            ],
          ),
        ],
      ),
    );
  }
}
