import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/non_contribution/controllers/non_contribution_controller.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/non_contribution/controllers/add_income_non_contribution_controller.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/resident_bill/controllers/resident_bill_controller.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/resident_bill/controllers/resident_bill_detail_controller.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/treasurer_bill/controllers/treasurer_bill_controller.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/treasurer_bill/controllers/assign_bill_form_controller.dart';

class IncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NonContributionController>(() => NonContributionController());
    Get.lazyPut<AddIncomeNonContributionController>(
      () => AddIncomeNonContributionController(),
    );
    Get.lazyPut<ResidentBillController>(() => ResidentBillController());
    Get.lazyPut<ResidentBillDetailController>(
      () => ResidentBillDetailController(),
    );
    Get.lazyPut<TreasurerBillController>(() => TreasurerBillController());
    Get.lazyPut<AssignBillFormController>(() => AssignBillFormController());
    Get.lazyPut<IncomeController>(() => IncomeController());
  }
}
