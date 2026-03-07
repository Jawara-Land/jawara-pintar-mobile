import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
