import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';
import '../models/income_category_model.dart';
import '../models/income_non_contribution_model.dart';
import '../models/contribution_category_model.dart';
import '../models/family_contribution_model.dart';
import '../models/bill_history_group_model.dart';
import 'package:jawara_mobile/modules/features/data/models/family_model.dart';
import '../sub_features/non_contribution/controllers/non_contribution_controller.dart';
import '../sub_features/resident_bill/controllers/resident_bill_controller.dart';
import '../sub_features/treasurer_bill/controllers/treasurer_bill_controller.dart';

class IncomeController extends GetxController with GetSingleTickerProviderStateMixin {
  static IncomeController get to => Get.find();

  late TabController tabController;

  // Sub Controllers
  late final NonContributionController nonContributionController;
  late final ResidentBillController residentBillController;
  late final TreasurerBillController treasurerBillController;

  // Roles checking
  final RxList<String> roles = <String>[].obs;
  bool get isTreasurer =>
      roles.contains('treasurer') || roles.contains('admin');
  bool get isResident => roles.contains('resident');

  // Non-Contribution
  List<IncomeNonContributionModel> get nonContributionIncomes =>
      nonContributionController.nonContributionIncomes;
  List<IncomeCategoryModel> get incomeCategories =>
      nonContributionController.incomeCategories;
  RxBool get isLoadingNonContribution =>
      nonContributionController.isLoadingNonContribution;
  RxBool get isStoringNonContribution =>
      nonContributionController.isStoringNonContribution;
  RxString get searchNonContributionQuery =>
      nonContributionController.searchNonContributionQuery;
  RxnInt get filterCategoryId => nonContributionController.filterCategoryId;
  RxnString get filterFromDate => nonContributionController.filterFromDate;
  RxnString get filterToDate => nonContributionController.filterToDate;

  // Resident / Family Contribution
  List<FamilyContributionModel> get residentBills =>
      residentBillController.residentBills;
  RxBool get isLoadingResidentBills =>
      residentBillController.isLoadingResidentBills;

  // Treasurer Billing & Approvals
  List<FamilyContributionModel> get allBills =>
      treasurerBillController.allBills;
  List<ContributionCategoryModel> get contributionCategories =>
      treasurerBillController.contributionCategories;
  List<BillHistoryGroupModel> get billsHistory =>
      treasurerBillController.billsHistory;
  RxBool get isLoadingAllBills => treasurerBillController.isLoadingAllBills;
  RxBool get isLoadingContributorCategories =>
      treasurerBillController.isLoadingContributorCategories;
  RxBool get isLoadingHistory => treasurerBillController.isLoadingHistory;

  // Assign Billing elements
  List<FamilyModel> get familiesList => treasurerBillController.familiesList;
  RxList<int> get selectedFamilyIds =>
      treasurerBillController.selectedFamilyIds;
  RxnInt get selectedAssignContributionId =>
      treasurerBillController.selectedAssignContributionId;
  Rx<DateTime> get selectedAssignMonth =>
      treasurerBillController.selectedAssignMonth;
  RxBool get isAssigning => treasurerBillController.isAssigning;

  @override
  void onInit() {
    super.onInit();
    nonContributionController = Get.put(NonContributionController());
    residentBillController = Get.put(ResidentBillController());
    treasurerBillController = Get.put(TreasurerBillController());

    final authUser = Get.find<AuthController>().currentUser.value;
    if (authUser != null) {
      roles.assignAll(authUser.roles);
    }

    // Initialize tabs based on user role
    int count = isTreasurer ? 4 : 2;
    tabController = TabController(length: count, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    Get.delete<NonContributionController>();
    Get.delete<ResidentBillController>();
    Get.delete<TreasurerBillController>();
    super.onClose();
  }

  void refreshAll() {
    nonContributionController.fetchNonContributionCategories();
    nonContributionController.fetchNonContribution(refresh: true);

    if (isTreasurer) {
      treasurerBillController.refreshAll();
    } else {
      residentBillController.fetchResidentBills();
    }
  }

  Future<void> fetchNonContribution({bool refresh = true}) =>
      nonContributionController.fetchNonContribution(refresh: refresh);

  Future<void> storeNonContribution({
    required String name,
    required int categoryId,
    required int amount,
    required String happenedAt,
    File? proofFile,
  }) => nonContributionController.storeNonContribution(
    name: name,
    categoryId: categoryId,
    amount: amount,
    happenedAt: happenedAt,
    proofFile: proofFile,
  );

  Future<void> fetchResidentBills() =>
      residentBillController.fetchResidentBills();

  Future<void> uploadProofAndSubmit(int billId, File file) =>
      residentBillController.uploadProofAndSubmit(billId, file);

  Future<void> fetchContributionCategories() =>
      treasurerBillController.fetchContributionCategories();

  Future<void> fetchAllBills({bool refresh = true}) =>
      treasurerBillController.fetchAllBills(refresh: refresh);

  Future<void> fetchBillsHistory() =>
      treasurerBillController.fetchBillsHistory();

  Future<Map<String, dynamic>> storeContributionCategory({
    required String name,
    required int amount,
    required int contributionCategoryId,
  }) => treasurerBillController.storeContributionCategory(
    name: name,
    amount: amount,
    contributionCategoryId: contributionCategoryId,
  );

  Future<void> fetchFamiliesForAssign() =>
      treasurerBillController.fetchFamiliesForAssign();

  Future<void> processAssignBills() =>
      treasurerBillController.processAssignBills();

  Future<void> approveBillPayment(int id) =>
      treasurerBillController.approveBillPayment(id);

  Future<void> rejectBillPayment(int id, String reason) =>
      treasurerBillController.rejectBillPayment(id, reason);
}
