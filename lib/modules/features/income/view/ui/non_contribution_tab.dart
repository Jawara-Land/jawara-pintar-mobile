import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/modules/features/income/view/components/non_contribution_income_card.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class NonContributionTab extends StatelessWidget {
  const NonContributionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = IncomeController.to;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextFormField(
            onChanged: (val) =>
                controller.searchNonContributionQuery.value = val,
            decoration: InputDecoration(
              hintText: 'Cari kas / pemasukan lain...',
              prefixIcon: const Icon(Icons.search),
              fillColor: AppColor.inputFill,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColor.inputBorder),
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingNonContribution.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              );
            }

            if (controller.nonContributionIncomes.isEmpty) {
              return const Center(
                child: Text('Tidak ada pemasukan lain ditemukan.'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  controller.fetchNonContribution(refresh: true),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.nonContributionIncomes.length,
                itemBuilder: (context, index) {
                  final item = controller.nonContributionIncomes[index];
                  return NonContributionIncomeCard(item: item);
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
