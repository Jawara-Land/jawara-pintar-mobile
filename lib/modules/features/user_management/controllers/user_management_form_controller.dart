import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/user_management/controllers/user_management_controller.dart';
import 'package:jawara_mobile/modules/features/user_management/models/user_model.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class UserManagementFormController extends GetxController {
  final UserManagementController _parentController =
      Get.find<UserManagementController>();

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nikController = TextEditingController();
  final passwordController = TextEditingController();

  final selectedRole = Rxn<String>();
  final selectedGender = Rxn<String>();
  final selectedOccupancyStatus = Rxn<String>();
  final selectedHouseId = Rxn<int>();
  final isSubmitting = false.obs;
  final isEdit = false.obs;

  UserModel? existingUser;

  final List<String> roles = const [
    'admin',
    'community_head',
    'neighborhood_head',
    'secretary',
    'treasurer',
    'resident',
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is UserModel) {
      existingUser = Get.arguments as UserModel;
      isEdit(true);
      _populateFromUser(existingUser!);
    }
  }

  void _populateFromUser(UserModel user) {
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phoneNumber ?? '';
    nikController.text = user.nik ?? '';
    if (user.roles.isNotEmpty && roles.contains(user.roles.first)) {
      selectedRole.value = user.roles.first;
    }
    selectedGender.value = user.gender;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    isSubmitting(true);
    try {
      final payload = _buildPayload();

      bool success;
      if (isEdit.value) {
        success = await _parentController.updateUser(existingUser!.id, payload);
      } else {
        success = await _parentController.createUser(payload);
      }

      if (success) {
        Get.back();
      }
    } catch (e) {
      Sentry.captureException(e);
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isSubmitting(false);
    }
  }

  Map<String, dynamic> _buildPayload() {
    final payload = <String, dynamic>{
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone_number': phoneController.text.trim(),
      'role': selectedRole.value,
    };

    final nik = nikController.text.trim();
    if (nik.isNotEmpty) payload['nik'] = nik;

    if (selectedGender.value != null) {
      payload['gender'] = selectedGender.value;
    }

    final password = passwordController.text.trim();
    if (!isEdit.value || password.isNotEmpty) {
      payload['password'] = password;
      payload['password_confirmation'] = password;
    }

    if (selectedRole.value == 'resident') {
      payload['occupancy_status'] = selectedOccupancyStatus.value ?? 'renter';
      if (selectedHouseId.value != null) {
        payload['current_house_id'] = selectedHouseId.value;
      }
    }

    return payload;
  }

  String? validateRequired(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Wajib diisi' : null;

  String? validatePassword(String? value) {
    if (!isEdit.value && (value == null || value.isEmpty)) return 'Wajib diisi';
    if (value != null && value.isNotEmpty && value.length < 8) {
      return 'Minimal 8 karakter';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Wajib diisi';
    if (!value.contains('@')) return 'Format email tidak valid';
    return null;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nikController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
