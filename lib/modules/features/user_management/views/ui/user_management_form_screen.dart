import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/user_management/controllers/user_management_form_controller.dart';
import 'package:jawara_mobile/shared/styles/app_color.dart';

class UserManagementFormScreen extends GetView<UserManagementFormController> {
  const UserManagementFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEdit.value ? 'Edit Pengguna' : 'Tambah Pengguna',
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isSubmitting.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AppFormField(
                  controller: controller.nameController,
                  label: 'Nama Lengkap',
                  validator: controller.validateRequired,
                ),
                
                SizedBox(height: 16),

                _AppFormField(
                  controller: controller.emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                
                SizedBox(height: 16),

                _AppFormField(
                  controller: controller.phoneController,
                  label: 'Nomor HP (08...)',
                  keyboardType: TextInputType.phone,
                  validator: controller.validateRequired,
                ),
                
                SizedBox(height: 16),

                _AppFormField(
                  controller: controller.nikController,
                  label: 'NIK (Opsional untuk beberapa role)',
                  keyboardType: TextInputType.number,
                ),
                
                SizedBox(height: 16),

                Obx(
                  () => _AppDropdownField<String>(
                    value: controller.selectedRole.value,
                    label: 'Role / Jabatan',
                    items: controller.roles
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (val) => controller.selectedRole.value = val,
                    validator: (val) => val == null ? 'Pilih peran' : null,
                  ),
                ),
                
                SizedBox(height: 16),

                Obx(
                  () => _AppDropdownField<String>(
                    value: controller.selectedGender.value,
                    label: 'Jenis Kelamin',
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Laki-laki')),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text('Perempuan'),
                      ),
                    ],
                    onChanged: (val) => controller.selectedGender.value = val,
                  ),
                ),
                
                SizedBox(height: 16),

                Obx(
                  () => _AppFormField(
                    controller: controller.passwordController,
                    label: controller.isEdit.value
                        ? 'Password Baru (Opsional)'
                        : 'Password',
                    obscureText: true,
                    validator: controller.validatePassword,
                  ),
                ),
                
                SizedBox(height: 32),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: controller.submit,
                  child: Obx(
                    () => Text(
                      controller.isEdit.value
                          ? 'Simpan Perubahan'
                          : 'Buat Pengguna',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _AppFormField extends StatelessWidget {
  const _AppFormField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

class _AppDropdownField<T> extends StatelessWidget {
  const _AppDropdownField({
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  final T? value;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
