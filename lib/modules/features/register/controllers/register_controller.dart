import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
  var selectedRumah = Rxn<String>();
  var selectedStatusRumah = Rxn<String>();

  final ImagePicker _imagePicker = ImagePicker();
  var selectedKtpImage = Rxn<File>();

  final List<String> jenisKelaminOptions = ['Laki-laki', 'Perempuan'];
  final List<String> rumaOptions = ['Rumah Ina', 'Rumah Dua', 'Rumah Tiga'];
  final List<String> statusRumahOptions = ['Pemilik', 'Penghuni', 'Penyewa'];

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

  void register() {
    if (formKey.currentState!.validate()) {
      Get.snackbar(
        'Register',
        'Registrasi berhasil untuk ${namaLengkapCtrl.text}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
