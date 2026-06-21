import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../models/family_contribution_model.dart';
import '../../../sub_features/resident_bill/repositories/resident_bill_repository.dart';

class ResidentBillController extends GetxController {
  static ResidentBillController get to => Get.find();

  final RxList<FamilyContributionModel> residentBills =
      <FamilyContributionModel>[].obs;
  final RxBool isLoadingResidentBills = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchResidentBills();
  }

  Future<void> fetchResidentBills() async {
    isLoadingResidentBills.value = true;
    try {
      final list = await ResidentBillRepository.getResidentBills();
      residentBills.assignAll(list);
    } catch (e, stack) {
      Sentry.captureException(e, stackTrace: stack);
    } finally {
      isLoadingResidentBills.value = false;
    }
  }

  Future<void> uploadProofAndSubmit(int billId, File file) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final result = await ResidentBillRepository.uploadPaymentProof(
        billId,
        file,
      );
      Get.back();

      if (result['success'] == true) {
        Get.back();
        Get.snackbar(
          'Sukses',
          'Bukti bayar berhasil diunggah! Status menunggu verifikasi.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchResidentBills();
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Gagal mengunggah bukti pembayaran.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      Get.back();
      Sentry.captureException(e, stackTrace: stack);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
