import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/treasurer_bill/view/ui/manage_contribution_categories_screen.dart';
import 'package:jawara_mobile/modules/features/income/view/components/income_fab.dart';
import 'package:jawara_mobile/modules/features/income/view/components/reject_payment_dialog.dart';
import 'package:jawara_mobile/modules/features/income/view/ui/resident_bills_tab.dart';
import 'package:jawara_mobile/modules/features/income/view/ui/treasurer_bills_tab.dart';
import 'package:jawara_mobile/modules/features/income/view/ui/non_contribution_tab.dart';
import 'package:jawara_mobile/modules/features/income/view/ui/billing_history_tab.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class IncomeScreen extends GetView<IncomeController> {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isTreasurer = controller.isTreasurer;

      return Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
            onPressed: () => Get.back(),
          ),
          title: Text('Pemasukan & Iuran', style: AppTextStyle.headingMedium),
          bottom: TabBar(
            controller: controller.tabController,
            isScrollable: true,
            labelColor: AppColor.primary,
            unselectedLabelColor: AppColor.textTertiary,
            indicatorColor: AppColor.primary,
            indicatorWeight: 3,
            labelStyle: AppTextStyle.titleMedium,
            unselectedLabelStyle: AppTextStyle.bodySmall,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: isTreasurer
                ? [
                    Tab(text: 'Kategori Iuran'),
                    Tab(text: 'Tagihan Iuran'),
                    Tab(text: 'Pemasukan Lain'),
                    Tab(text: 'Riwayat Penagihan'),
                  ]
                : const [
                    Tab(text: 'Tagihan Saya'),
                    Tab(text: 'Pemasukan Umum'),
                  ],
          ),
        ),
        body: TabBarView(
          controller: controller.tabController,
          children: isTreasurer
              ? [
                  ManageContributionCategoriesScreen(),
                  TreasurerBillsTab(onReject: _showRejectDialog),
                  NonContributionTab(),
                  BillingHistoryTab(),
                ]
              : [const ResidentBillsTab(), const NonContributionTab()],
        ),
        floatingActionButton: IncomeFAB(
          tabController: controller.tabController,
        ),
      );
    });
  }

  void _showRejectDialog(int id) {
    Get.dialog(RejectPaymentDialog(billId: id));
  }
}
