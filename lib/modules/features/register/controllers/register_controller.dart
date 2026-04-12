import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/register/models/house_model.dart';
import 'package:jawara_mobile/modules/features/register/models/register_response.dart';
import 'package:jawara_mobile/modules/features/register/repositories/register_repository.dart';

class RegisterController extends GetxController {
  static RegisterController get to => Get.find();

  var formKey = GlobalKey<FormState>();
  var namaLengkapCtrl = TextEditingController();
  var nikCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var noTelponCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  var confirmPasswordCtrl = TextEditingController();
  var alamatRumahCtrl = TextEditingController();

  var isPassword = true.obs;
  var isConfirmPassword = true.obs;
  var selectedJenisKelamin = Rxn<String>();
  var selectedHouseId = Rxn<int>();
  var selectedStatusRumah = Rxn<String>();

  final ImagePicker _imagePicker = ImagePicker();
  var selectedKtpImage = Rxn<File>();

  // API-driven data
  var houses = <HouseModel>[].obs;
  var isLoadingHouses = false.obs;

  // Loading & error states
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // UI display options
  final List<String> jenisKelaminOptions = ['Laki-laki', 'Perempuan'];
  final List<String> statusRumahOptions = ['Pemilik', 'Penyewa'];

  // Maps UI display labels to API values
  static const Map<String, String> _genderMap = {
    'Laki-laki': 'male',
    'Perempuan': 'female',
  };

  static const Map<String, String> _occupancyMap = {
    'Pemilik': 'owner',
    'Penyewa': 'renter',
  };

  @override
  void onInit() {
    super.onInit();
    _loadHouses();
  }

  @override
  void onClose() {
    namaLengkapCtrl.dispose();
    nikCtrl.dispose();
    emailCtrl.dispose();
    noTelponCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    alamatRumahCtrl.dispose();
    super.onClose();
  }

  Future<void> _loadHouses() async {
    isLoadingHouses.value = true;
    try {
      final response = await RegisterRepository.getHouses();
      if (response.success) {
        houses.value = response.houses;
      } else {
        Get.snackbar(
          'Peringatan',
          'Gagal memuat daftar rumah: ${response.message}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } on TimeoutException {
      Get.snackbar(
        'Timeout',
        'Gagal memuat daftar rumah. Server tidak merespons.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } on SocketException {
      Get.snackbar(
        'Koneksi Gagal',
        'Tidak ada koneksi internet untuk memuat daftar rumah.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat daftar rumah.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoadingHouses.value = false;
    }
  }

  void toggleShowPassword() {
    isPassword.value = !isPassword.value;
  }

  void toggleShowConfirmPassword() {
    isConfirmPassword.value = !isConfirmPassword.value;
  }

  void pickKtpImage() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            const Center(
              child: Text(
                'Pilih Sumber Foto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16, width: double.infinity),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeri'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Kamera'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        selectedKtpImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil gambar: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeKtpImage() {
    selectedKtpImage.value = null;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    // Validate identity photo
    if (selectedKtpImage.value == null) {
      Get.snackbar(
        'Foto Identitas',
        'Silakan unggah foto identitas (KK/KTP).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.photo_outlined, color: Colors.white),
      );
      return;
    }

    // Validate either house selection or manual address
    if (selectedHouseId.value == null &&
        alamatRumahCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Alamat Rumah',
        'Pilih rumah dari daftar atau isi alamat rumah.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.home_outlined, color: Colors.white),
      );
      return;
    }

    errorMessage.value = '';
    isLoading.value = true;

    try {
      final gender = _genderMap[selectedJenisKelamin.value] ?? 'male';
      final occupancy =
          _occupancyMap[selectedStatusRumah.value] ?? 'owner';

      final RegisterResponse response = await RegisterRepository.register(
        name: namaLengkapCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        nik: nikCtrl.text.trim(),
        gender: gender,
        phoneNumber: noTelponCtrl.text.trim(),
        identityPhoto: selectedKtpImage.value!,
        password: passwordCtrl.text,
        passwordConfirmation: confirmPasswordCtrl.text,
        tempOccupancyStatus: occupancy,
        tempHouseId: selectedHouseId.value,
        tempAddress: alamatRumahCtrl.text.trim().isNotEmpty
            ? alamatRumahCtrl.text.trim()
            : null,
      );

      if (response.success) {
        Get.offAllNamed(Routes.loginRoute);

        Get.snackbar(
          'Registrasi Berhasil',
          response.message.isNotEmpty
              ? response.message
              : 'Silakan tunggu persetujuan admin! 🎉',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        _handleRegisterError(response);
      }
    } on TimeoutException {
      errorMessage.value = 'Koneksi timeout. Server tidak merespons.';
      Get.snackbar(
        'Timeout',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.timer_off, color: Colors.white),
      );
    } on SocketException {
      errorMessage.value = 'Tidak ada koneksi internet.';
      Get.snackbar(
        'Koneksi Gagal',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.wifi_off, color: Colors.white),
      );
    } on http.ClientException {
      errorMessage.value =
          'Gagal menghubungi server. Pastikan server berjalan.';
      Get.snackbar(
        'Server Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.cloud_off, color: Colors.white),
      );
    } on FormatException {
      errorMessage.value = 'Terjadi kesalahan pada server. Silakan coba lagi.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan. Silakan coba lagi.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _handleRegisterError(RegisterResponse response) {
    if (response.errors != null) {
      // Collect all field errors into a single readable message
      final errorMessages = <String>[];
      response.errors!.forEach((field, messages) {
        errorMessages.addAll(messages);
      });

      if (errorMessages.isNotEmpty) {
        errorMessage.value = errorMessages.join('\n');
      }
    }

    switch (response.statusCode) {
      case 422:
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Periksa kembali data yang Anda masukkan.';

        Get.snackbar(
          'Validasi Gagal',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
        break;
      default:
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Terjadi kesalahan. Silakan coba lagi.';

        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
    }
  }
}
