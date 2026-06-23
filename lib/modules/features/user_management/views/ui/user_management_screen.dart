import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/user_management/controllers/user_management_controller.dart';
import 'package:jawara_mobile/modules/features/user_management/views/components/pending_residents_view.dart';
import 'package:jawara_mobile/modules/features/user_management/views/components/user_list_view.dart';
import 'package:jawara_mobile/shared/styles/app_color.dart';

class UserManagementScreen extends GetView<UserManagementController> {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen Pengguna'),
          bottom: const TabBar(
            labelColor: AppColor.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColor.primary,
            tabs: [
              Tab(text: 'Daftar Pengguna'),
              Tab(text: 'Persetujuan Warga'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [UserListView(), PendingResidentsView()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.userManagementFormRoute),
          backgroundColor: AppColor.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
