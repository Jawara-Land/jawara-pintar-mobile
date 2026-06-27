import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/finance/finance_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class FinanceIncomesScreen extends GetView<FinanceController> {
  const FinanceIncomesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.incomes.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.errorMessage.value.isNotEmpty &&
          controller.incomes.isEmpty) {
        return AppEmptyState(
          icon: Icons.error_outline,
          message: controller.errorMessage.value,
          actionLabel: 'Coba Lagi',
          onAction: controller.fetchAllIncomes,
        );
      }
      if (controller.incomes.isEmpty) {
        return const AppEmptyState(
          icon: Icons.payments_outlined,
          message: 'Belum ada data pemasukan.',
        );
      }
      return RefreshIndicator(
        onRefresh: controller.fetchAllIncomes,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.incomes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final item = controller.incomes[index];
            return ListTile(
              tileColor: AppColor.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                item['name']?.toString() ?? '-',
                style: AppTextStyle.titleMedium,
              ),
              subtitle: Text(item['income_category']?.toString() ?? 'Umum'),
              trailing: Text(item['amount']?.toString() ?? '0'),
            );
          },
        ),
      );
    });
  }
}
