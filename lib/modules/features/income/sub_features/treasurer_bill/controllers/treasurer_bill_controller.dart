import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../models/contribution_category_model.dart';
import '../../../models/family_contribution_model.dart';
import '../../../models/bill_history_group_model.dart';
import '../../../sub_features/treasurer_bill/repositories/treasurer_bill_repository.dart';
import 'package:jawara_mobile/modules/features/data/models/family_model.dart';
import 'package:jawara_mobile/modules/features/data/repositories/data_repository.dart';

class TreasurerBillController extends GetxController {
  static TreasurerBillController get to => Get.find();

  final RxList<FamilyContributionModel> allBills =
      <FamilyContributionModel>[].obs;
  final RxList<ContributionCategoryModel> contributionCategories =
      <ContributionCategoryModel>[].obs;
  final RxList<BillHistoryGroupModel> billsHistory =
      <BillHistoryGroupModel>[].obs;
  final RxBool isLoadingAllBills = false.obs;
  final RxBool isLoadingContributorCategories = false.obs;
  final RxBool isLoadingHistory = false.obs;

  // Assign Billing elements
  final RxList<FamilyModel> familiesList = <FamilyModel>[].obs;
  final RxList<int> selectedFamilyIds = <int>[].obs;
  final RxnInt selectedAssignContributionId = RxnInt();
  final Rx<DateTime> selectedAssignMonth = DateTime.now().obs;
  final RxBool isAssigning = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContributionCategories();
    fetchAllBills(refresh: true);
    fetchBillsHistory();
    fetchFamiliesForAssign();
  }

  void refreshAll() {
    fetchContributionCategories();
    fetchAllBills(refresh: true);
    fetchBillsHistory();
    fetchFamiliesForAssign();
  }

  Future<void> fetchContributionCategories() async {
    isLoadingContributorCategories.value = true;
    try {
      final list = await TreasurerBillRepository.getContributionCategories();
      contributionCategories.assignAll(list);
    } catch (e, stack) {
      Sentry.captureException(e, stackTrace: stack);
    } finally {
      isLoadingContributorCategories.value = false;
    }
  }

  Future<void> fetchAllBills({bool refresh = true}) async {
    isLoadingAllBills.value = true;
    try {
      final res = await TreasurerBillRepository.getBillsList();
      if (res['success'] == true) {
        final List<FamilyContributionModel> items = res['bills'];
        allBills.assignAll(items);
      }
    } catch (e, stack) {
      Sentry.captureException(e, stackTrace: stack);
    } finally {
      isLoadingAllBills.value = false;
    }
  }

  Future<void> fetchBillsHistory() async {
    isLoadingHistory.value = true;
    try {
      final list = await TreasurerBillRepository.getBillsHistory();
      billsHistory.assignAll(list);
    } catch (e, stack) {
      Sentry.captureException(e, stackTrace: stack);
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<Map<String, dynamic>> storeContributionCategory({
    required String name,
    required int amount,
    required int contributionCategoryId,
  }) async {
    try {
      return await TreasurerBillRepository.storeContributionCategory(
        name: name,
        amount: amount,
        contributionCategoryId: contributionCategoryId,
      );
    } catch (e, stack) {
      Sentry.captureException(e, stackTrace: stack);
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> fetchFamiliesForAssign() async {
    try {
      final list = await DataRepository.getFamilyOptions();
      familiesList.assignAll(list);
    } catch (e, stack) {
      Sentry.captureException(e, stackTrace: stack);
    }
  }

  Future<void> processAssignBills() async {
    if (selectedAssignContributionId.value == null) {
      Get.snackbar('Error', 'Silakan pilih kategori iuran terlebih dahulu.');
      return;
    }
    if (selectedFamilyIds.isEmpty) {
      Get.snackbar('Error', 'Silakan pilih minimal satu keluarga.');
      return;
    }

    isAssigning.value = true;
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final monthStr =
          '${selectedAssignMonth.value.year}-${selectedAssignMonth.value.month.toString().padLeft(2, '0')}';
      final result = await TreasurerBillRepository.assignBills(
        contributionId: selectedAssignContributionId.value!,
        familyIds: selectedFamilyIds,
        month: monthStr,
      );

      Get.back();

      if (result['success'] == true) {
        Get.back();
        Get.snackbar(
          'Sukses',
          result['message'] ??
              'Tagihan berhasil dibuat untuk keluarga terpilih!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        refreshAll();
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Gagal membuat tagihan.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      if (Get.isDialogOpen ?? false) Get.back();
      Sentry.captureException(e, stackTrace: stack);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isAssigning.value = false;
    }
  }

  Future<void> approveBillPayment(int id) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await TreasurerBillRepository.approvePayment(id);
      Get.back();

      if (result['success'] == true) {
        Get.snackbar(
          'Sukses',
          'Pembayaran iuran disetujui.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchAllBills(refresh: true);
        fetchBillsHistory();
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Gagal menyetujui pembayaran.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      if (Get.isDialogOpen ?? false) Get.back();
      Sentry.captureException(e, stackTrace: stack);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  Future<void> rejectBillPayment(int id, String reason) async {
    if (reason.trim().isEmpty) {
      Get.snackbar('Error', 'Alasan penolakan tidak boleh kosong.');
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await TreasurerBillRepository.rejectPayment(
        id,
        reason: reason,
      );
      Get.back();

      if (result['success'] == true) {
        Get.back();
        Get.snackbar(
          'Sukses',
          'Pembayaran iuran ditolak.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        fetchAllBills(refresh: true);
        fetchBillsHistory();
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Gagal menolak pembayaran.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      if (Get.isDialogOpen ?? false) Get.back();
      Sentry.captureException(e, stackTrace: stack);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
