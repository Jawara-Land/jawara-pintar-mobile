import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/finance/finance_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class FinanceScreen extends GetView<FinanceController> {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          title: const Text('Laporan Keuangan'),
          actions: [
            IconButton(
              onPressed: () => Get.toNamed(Routes.financeIncomeRoute),
              icon: const Icon(Icons.arrow_upward),
            ),
            IconButton(
              onPressed: () => Get.toNamed(Routes.financeExpenseRoute),
              icon: const Icon(Icons.arrow_downward),
            ),
            IconButton(
              onPressed: () => Get.toNamed(Routes.financeReportRoute),
              icon: const Icon(Icons.print),
            ),
          ],
        ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: controller.dashboard.entries
                    .map(
                      (entry) => ListTile(
                        title: Text(entry.key),
                        trailing: Text(entry.value.toString()),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
