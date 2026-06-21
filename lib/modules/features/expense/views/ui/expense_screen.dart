import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_empty_state.dart';
import '../../controllers/expense_controller.dart';
import '../components/expense_card.dart';

class ExpenseScreen extends GetView<ExpenseController> {
  const ExpenseScreen({super.key});

  static const _writeRoles = ['admin', 'community_head', 'treasurer'];

  bool get _canCreate {
    final roles = Get.find<AuthController>().currentUser.value?.roles ?? [];
    return roles.any((r) => _writeRoles.contains(r));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        title: Text('Pengeluaran', style: AppTextStyle.headingSmall),
        centerTitle: false,
      ),
      floatingActionButton: _canCreate
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(Routes.expenseCreateRoute),
              backgroundColor: AppColor.primary,
              icon: const Icon(Icons.add, color: AppColor.onPrimary),
              label: Text(
                'Tambah',
                style: AppTextStyle.labelLarge.copyWith(
                  color: AppColor.onPrimary,
                ),
              ),
            )
          : null,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextFormField(
              onChanged: (val) => controller.fetchExpenses(name: val.trim()),
              decoration: InputDecoration(
                hintText: 'Cari pengeluaran...',
                hintStyle: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.textHint,
                ),
                prefixIcon:
                    const Icon(Icons.search, color: AppColor.textTertiary),
                filled: true,
                fillColor: AppColor.inputFill,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColor.primary, width: 1.5),
                ),
              ),
            ),
          ),
          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.expenses.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.primary),
                );
              }

              if (controller.errorMessage.isNotEmpty &&
                  controller.expenses.isEmpty) {
                return AppEmptyState(
                  icon: Icons.error_outline,
                  message: controller.errorMessage.value,
                  actionLabel: 'Coba Lagi',
                  onAction: () => controller.fetchExpenses(),
                );
              }

              if (controller.expenses.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.receipt_long_outlined,
                  message: 'Belum ada data pengeluaran.',
                );
              }

              return RefreshIndicator(
                color: AppColor.primary,
                onRefresh: () => controller.fetchExpenses(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: controller.expenses.length,
                  itemBuilder: (_, index) =>
                      ExpenseCard(expense: controller.expenses[index]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
