import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/modules/features/income/view/components/billing_history_card.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class BillingHistoryTab extends StatelessWidget {
  const BillingHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = IncomeController.to;
    return Obx(() {
      if (controller.isLoadingHistory.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColor.primary),
        );
      }

      if (controller.billsHistory.isEmpty) {
        return const Center(child: Text('Riwayat penagihan kosong.'));
      }

      return RefreshIndicator(
        onRefresh: () async => controller.fetchBillsHistory(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.billsHistory.length,
          itemBuilder: (context, index) {
            final group = controller.billsHistory[index];
            return BillingHistoryCard(group: group);
          },
        ),
      );
    });
  }
}
