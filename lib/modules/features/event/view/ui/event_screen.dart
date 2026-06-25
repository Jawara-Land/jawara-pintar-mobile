import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import '../../controllers/event_controller.dart';

class EventScreen extends GetView<EventController> {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'Kegiatan',
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
                onPressed: () => Get.toNamed(Routes.eventFormRoute),
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

        if (controller.events.isEmpty) {
          return const Center(child: Text('Tidak ada kegiatan tersedia.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.events.length,
          itemBuilder: (context, index) {
            final event = controller.events[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: AppColor.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 2),
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
                          Text(event.date, style: AppTextStyle.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(event.name, style: AppTextStyle.titleLarge),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.groups,
                        size: 20,
                        color: AppColor.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.category,
                          style: AppTextStyle.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 20,
                        color: AppColor.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.creator,
                          style: AppTextStyle.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
