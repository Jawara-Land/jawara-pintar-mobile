import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/modules/features/income/view/components/treasurer_bill_card.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class TreasurerBillsTab extends StatelessWidget {
  const TreasurerBillsTab({required this.onReject, super.key});

  final Function(int) onReject;

  @override
  Widget build(BuildContext context) {
    final controller = IncomeController.to;
    return Obx(() {
      if (controller.isLoadingAllBills.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColor.primary),
        );
      }

      if (controller.allBills.isEmpty) {
        return const Center(child: Text('Tidak ada data tagihan warga.'));
      }

      return RefreshIndicator(
        onRefresh: () async => controller.fetchAllBills(refresh: true),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.allBills.length,
          itemBuilder: (context, index) {
            final bill = controller.allBills[index];
            return TreasurerBillCard(
              bill: bill,
              onReject: () => onReject(bill.id),
              onApprove: () => controller.approveBillPayment(bill.id),
            );
          },
        ),
      );
    });
  }
}
