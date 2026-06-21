import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/modules/features/income/view/components/resident_bill_card.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class ResidentBillsTab extends StatelessWidget {
  const ResidentBillsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = IncomeController.to;
    return Obx(() {
      if (controller.isLoadingResidentBills.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColor.primary),
        );
      }

      if (controller.residentBills.isEmpty) {
        return const Center(child: Text('Tidak ada tagihan iuran keluarga.'));
      }

      return RefreshIndicator(
        onRefresh: () async => controller.fetchResidentBills(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.residentBills.length,
          itemBuilder: (context, index) {
            final bill = controller.residentBills[index];
            return ResidentBillCard(bill: bill);
          },
        ),
      );
    });
  }
}
