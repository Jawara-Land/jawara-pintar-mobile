import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/models/address_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/repositories/address_repository.dart';

class AddressController extends GetxController {
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxBool isLoading = false.obs;

  final addressController = TextEditingController();
  final labelController = TextEditingController();
  final phoneController = TextEditingController();
  final isPrimary = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  @override
  void onClose() {
    addressController.dispose();
    labelController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> fetchAddresses() async {
    isLoading.value = true;
    try {
      final response = await AddressRepository.getAddresses();
      if (response['success'] == true) {
        final List data = response['data']['addresses'] ?? [];
        addresses.value = data.map((e) => AddressModel.fromJson(e)).toList();
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Gagal memuat alamat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void populateForm(AddressModel address) {
    addressController.text = address.address;
    labelController.text = address.label ?? '';
    phoneController.text = address.phone ?? '';
    isPrimary.value = address.isPrimary;
  }

  void clearForm() {
    addressController.clear();
    labelController.clear();
    phoneController.clear();
    isPrimary.value = false;
  }

  Future<bool> saveAddress({int? id}) async {
    if (addressController.text.isEmpty) {
      Get.snackbar('Error', 'Alamat tidak boleh kosong');
      return false;
    }

    isLoading.value = true;
    try {
      Map<String, dynamic> response;
      if (id != null) {
        response = await AddressRepository.updateAddress(
          id,
          address: addressController.text,
          label: labelController.text.isEmpty ? null : labelController.text,
          phone: phoneController.text.isEmpty ? null : phoneController.text,
          isPrimary: isPrimary.value,
        );
      } else {
        response = await AddressRepository.createAddress(
          address: addressController.text,
          label: labelController.text.isEmpty ? null : labelController.text,
          phone: phoneController.text.isEmpty ? null : phoneController.text,
          isPrimary: isPrimary.value,
        );
      }

      if (response['success'] == true) {
        Get.snackbar(
          'Sukses',
          response['message'] ?? 'Alamat berhasil disimpan',
        );
        fetchAddresses();
        return true;
      } else {
        Get.snackbar('Error', response['message'] ?? 'Gagal menyimpan alamat');
        return false;
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      final response = await AddressRepository.deleteAddress(id);
      if (response['success'] == true) {
        addresses.removeWhere((element) => element.id == id);
        Get.snackbar(
          'Sukses',
          response['message'] ?? 'Alamat berhasil dihapus',
        );
        fetchAddresses();
      } else {
        Get.snackbar('Error', response['message'] ?? 'Gagal menghapus alamat');
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  Future<void> setPrimary(int id) async {
    try {
      final response = await AddressRepository.setPrimaryAddress(id);
      if (response['success'] == true) {
        Get.snackbar(
          'Sukses',
          response['message'] ?? 'Alamat utama berhasil diubah',
        );
        fetchAddresses();
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Gagal mengubah alamat utama',
        );
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
