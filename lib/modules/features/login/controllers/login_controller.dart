import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
