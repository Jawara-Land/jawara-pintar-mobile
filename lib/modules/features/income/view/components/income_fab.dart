import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class IncomeFAB extends StatelessWidget {
  const IncomeFAB({required this.tabController, super.key});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final controller = IncomeController.to;
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        final index = tabController.index;
        final isTreasurer = controller.isTreasurer;

        if (isTreasurer) {
          if (index == 1) {
            return FloatingActionButton.extended(
              onPressed: () => Get.toNamed(Routes.incomeAssignRoute),
              label: Text(
                'Buat Tagihan',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.add_card, color: Colors.white),
              backgroundColor: AppColor.primary,
            );
          } else if (index == 2) {
            return FloatingActionButton.extended(
              onPressed: () => Get.toNamed(Routes.incomeAddOtherRoute),
              label: Text(
                'Tambah Kas',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              backgroundColor: AppColor.primary,
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
