import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/login/models/login_response.dart';
import 'package:jawara_mobile/modules/features/login/repositories/login_repository.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  var formKey = GlobalKey<FormState>();
  var emailCtrl = TextEditingController();
  var emailValue = "".obs;
  var passwordCtrl = TextEditingController();
  var passwordValue = "".obs;
  var isPassword = true.obs;
  var isRememberMe = false.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  void toogleShowPassword() {
    if (isPassword.value == true) {
      isPassword.value = false;
    } else {
      isPassword.value = true;
    }
  }

  void _clearErrors() {
    errorMessage.value = '';
    emailError.value = '';
    passwordError.value = '';
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    _clearErrors();
    isLoading.value = true;

    try {
      final LoginResponse response = await LoginRepository.login(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
      );

      if (response.success) {
        if (response.user != null) {
          AuthController.to.setUser(response.user!);
        }

        final userName = response.user?.name ?? 'User';

        Get.offAllNamed(Routes.mainRoute);

        Get.snackbar(
          'Login Berhasil',
          'Selamat datang, $userName! 🎉',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 5),
        );
      } else {
        _handleLoginError(response);
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

  void _handleLoginError(LoginResponse response) {
    if (response.errors != null) {
      emailError.value = response.getFieldError('email') ?? '';
      passwordError.value = response.getFieldError('password') ?? '';
    }

    switch (response.statusCode) {
      case 401:
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Email atau kata sandi salah.';
        break;
      case 403:
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Akun kamu belum disetujui oleh admin.';

        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.hourglass_top, color: Colors.orange, size: 28),
                SizedBox(width: 8),
                Text('Menunggu Persetujuan'),
              ],
            ),
            content: Text(
              errorMessage.value,
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('OK')),
            ],
          ),
        );
        break;
      case 422:
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Periksa kembali data yang Anda masukkan.';
        break;
      case 429:
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Terlalu banyak percobaan. Silakan coba lagi nanti.';

        Get.snackbar(
          'Coba Lagi Nanti',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.timer, color: Colors.white),
          duration: const Duration(seconds: 5),
        );
        break;
      default:
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}
