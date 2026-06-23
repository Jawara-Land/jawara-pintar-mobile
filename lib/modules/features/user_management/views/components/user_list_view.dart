import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/user_management/controllers/user_management_controller.dart';
import 'package:jawara_mobile/modules/features/user_management/views/components/user_card.dart';
import 'package:jawara_mobile/shared/styles/app_color.dart';
import 'package:jawara_mobile/shared/widgets/app_empty_state.dart';
import 'package:jawara_mobile/shared/widgets/app_error_state.dart';
import 'package:jawara_mobile/shared/widgets/app_loading_state.dart';
import 'package:jawara_mobile/shared/widgets/search_field.dart';

class UserListView extends GetView<UserManagementController> {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(
          hintText: 'Cari pengguna...',
          onChanged: (value) =>
              controller.fetchUsers(refresh: true, search: value),
          padding: const EdgeInsets.all(16),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingUsers.value && controller.users.isEmpty) {
              return const AppLoadingState();
            }

            if (controller.errorMessageUsers.isNotEmpty &&
                controller.users.isEmpty) {
              return AppErrorState(
                message: controller.errorMessageUsers.value,
                onRetry: () => controller.fetchUsers(refresh: true),
              );
            }

            if (controller.users.isEmpty) {
              return const AppEmptyState(
                message: 'Tidak ada data pengguna',
                icon: Icons.people_outline,
              );
            }

            return RefreshIndicator(
              color: AppColor.primary,
              onRefresh: () => controller.fetchUsers(refresh: true),
              child: ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  final user = controller.users[index];

                  if (index == controller.users.length - 1 &&
                      !controller.isLoadingUsers.value) {
                    controller.fetchUsers();
                  }

                  return UserCard(
                    user: user,
                    onEdit: () => Get.toNamed(
                      Routes.userManagementFormRoute,
                      arguments: user,
                    ),
                    onDelete: () => controller.confirmDeleteUser(
                      context,
                      user.id,
                      user.name,
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
