import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/user_management/controllers/user_management_controller.dart';
import 'package:jawara_mobile/modules/features/user_management/views/components/user_card.dart';
import 'package:jawara_mobile/shared/styles/app_color.dart';
import 'package:jawara_mobile/shared/widgets/app_empty_state.dart';
import 'package:jawara_mobile/shared/widgets/app_error_state.dart';
import 'package:jawara_mobile/shared/widgets/app_loading_state.dart';

class PendingResidentsView extends GetView<UserManagementController> {
  const PendingResidentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPending.value &&
          controller.pendingResidents.isEmpty) {
        return const AppLoadingState();
      }

      if (controller.errorMessagePending.isNotEmpty &&
          controller.pendingResidents.isEmpty) {
        return AppErrorState(
          message: controller.errorMessagePending.value,
          onRetry: () => controller.fetchPendingResidents(refresh: true),
        );
      }

      if (controller.pendingResidents.isEmpty) {
        return const AppEmptyState(
          message: 'Tidak ada pendaftaran yang perlu disetujui',
          icon: Icons.done_all,
        );
      }

      return RefreshIndicator(
        color: AppColor.primary,
        onRefresh: () => controller.fetchPendingResidents(refresh: true),
        child: ListView.builder(
          itemCount: controller.pendingResidents.length,
          itemBuilder: (context, index) {
            final user = controller.pendingResidents[index];

            if (index == controller.pendingResidents.length - 1 &&
                !controller.isLoadingPending.value) {
              controller.fetchPendingResidents();
            }

            return UserCard(
              user: user,
              onApprove: () => controller.confirmApproveResident(
                context,
                user.id,
                user.name,
              ),
              onReject: () =>
                  controller.confirmRejectResident(context, user.id, user.name),
            );
          },
        ),
      );
    });
  }
}
