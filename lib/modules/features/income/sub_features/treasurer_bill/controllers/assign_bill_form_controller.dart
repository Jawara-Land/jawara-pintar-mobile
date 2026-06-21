import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/modules/features/income/models/contribution_category_model.dart';

class AssignBillFormController extends GetxController {
  final IncomeController incomeController = IncomeController.to;

  final Rxn<ContributionCategoryModel> selectedCategory =
      Rxn<ContributionCategoryModel>();
  final Rx<DateTime> selectedMonth = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    incomeController.selectedFamilyIds.assignAll(
      incomeController.familiesList.map((f) => f.id),
    );
    if (incomeController.contributionCategories.isNotEmpty) {
      final initialCategory = incomeController.contributionCategories.first;
      selectedCategory.value = initialCategory;
      incomeController.selectedAssignContributionId.value = initialCategory.id;
    }
  }

  Future<void> selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedMonth.value = picked;
      incomeController.selectedAssignMonth.value = picked;
    }
  }

  void onCategoryChanged(ContributionCategoryModel? val) {
    selectedCategory.value = val;
    incomeController.selectedAssignContributionId.value = val?.id;
  }
}
