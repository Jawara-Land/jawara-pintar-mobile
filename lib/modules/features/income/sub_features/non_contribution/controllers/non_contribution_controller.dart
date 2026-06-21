import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../models/income_category_model.dart';
import '../../../models/income_non_contribution_model.dart';
import '../../../sub_features/non_contribution/repositories/non_contribution_repository.dart';

class NonContributionController extends GetxController {
  static NonContributionController get to => Get.find();

  final RxList<IncomeNonContributionModel> nonContributionIncomes = <IncomeNonContributionModel>[].obs;
  final RxList<IncomeCategoryModel> incomeCategories = <IncomeCategoryModel>[].obs;
  final RxBool isLoadingNonContribution = false.obs;
  final RxBool isStoringNonContribution = false.obs;
  final RxString searchNonContributionQuery = ''.obs;
  final RxnInt filterCategoryId = RxnInt();
  final RxnString filterFromDate = RxnString();
  final RxnString filterToDate = RxnString();

  @override
  void onInit() {
    super.onInit();
    debounce(
      searchNonContributionQuery,
      (_) => fetchNonContribution(refresh: true),
      time: const Duration(milliseconds: 500),
    );
    fetchNonContributionCategories();
    fetchNonContribution(refresh: true);
  }

  Future<void> fetchNonContributionCategories() async {
    try {
      final list =
          await NonContributionRepository.getNonContributionCategories();
      incomeCategories.assignAll(list);
    } catch (e, stack) {
      Sentry.captureException(e, stackTrace: stack);
    }
  }

  Future<void> fetchNonContribution({bool refresh = true}) async {
    isLoadingNonContribution.value = true;
    try {
      final res = await NonContributionRepository.getNonContributionList(
        name: searchNonContributionQuery.value,
        categoryId: filterCategoryId.value,
        from: filterFromDate.value,
        to: filterToDate.value,
        page: 1,
      );
      if (res['success'] == true) {
        final List<IncomeNonContributionModel> items = res['incomes'];
        nonContributionIncomes.assignAll(items);
      }
    } catch (e, stack) {
      Sentry.captureException(e, stackTrace: stack);
    } finally {
      isLoadingNonContribution.value = false;
    }
  }

  Future<void> storeNonContribution({
    required String name,
    required int categoryId,
    required int amount,
    required String happenedAt,
    File? proofFile,
  }) async {
    isStoringNonContribution.value = true;
    try {
      final result = await NonContributionRepository.storeNonContributionIncome(
        name: name,
        categoryId: categoryId,
        amount: amount,
        happenedAt: happenedAt,
        proofFile: proofFile,
      );

      if (result['success'] == true) {
        Get.back();
        Get.snackbar(
          'Sukses',
          result['message'] ?? 'Pemasukan non iuran berhasil ditambahkan!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchNonContribution(refresh: true);
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Gagal membuat pemasukan',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      Sentry.captureException(e, stackTrace: stack);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isStoringNonContribution.value = false;
    }
  }
}
