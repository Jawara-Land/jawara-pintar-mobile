import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/modules/features/income/models/family_contribution_model.dart';
import 'package:jawara_mobile/modules/features/income/models/transfer_channel_model.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/resident_bill/repositories/resident_bill_repository.dart';

class ResidentBillDetailController extends GetxController {
  final IncomeController incomeController = IncomeController.to;

  final Rxn<FamilyContributionModel> bill = Rxn<FamilyContributionModel>();
  final RxBool isLoading = true.obs;
  final RxList<TransferChannelModel> channels = <TransferChannelModel>[].obs;
  final RxBool isLoadingChannels = false.obs;

  late final int billId;

  @override
  void onInit() {
    super.onInit();
    billId = Get.arguments as int;
    loadBillDetail();
  }

  Future<void> loadBillDetail() async {
    isLoading.value = true;
    try {
      final detail = await ResidentBillRepository.getResidentBillDetail(billId);
      bill.value = detail;
      if (detail.isUnpaid) {
        fetchChannels();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail tagihan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchChannels() async {
    isLoadingChannels.value = true;
    try {
      final list = await ResidentBillRepository.getTransferChannels();
      channels.assignAll(list);
    } catch (_) {
    } finally {
      isLoadingChannels.value = false;
    }
  }

  Future<void> pickAndUploadProof(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Kamera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await picker.pickImage(
        imageQuality: 70,
        source: source,
      );
      if (pickedFile != null) {
        incomeController.uploadProofAndSubmit(billId, File(pickedFile.path));
      }
    }
  }
}
