import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/register/constants/register_assets_constant.dart';
import 'package:jawara_mobile/modules/features/register/controllers/register_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundAlt,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: AppColor.backgroundAlt),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 24,
                left: 20,
                right: 20,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back_ios),
                    color: AppColor.textPrimary,
                  ),

                  Image.asset(
                    RegisterAssetsConstant.appLogo,
                    width: 40,
                    height: 40,
                  ),

                  SizedBox(width: 12),

                  Text('Jawara Pintar', style: AppTextStyle.titleLarge),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daftar Akun', style: AppTextStyle.headingMedium),

                      SizedBox(height: 4),

                      Text(
                        'Lengkapi formulir untuk membuat akun',
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text('Nama Lengkap', style: AppTextStyle.labelMedium),

                      SizedBox(height: 8),

                      TextFormField(
                        controller: controller.namaLengkapCtrl,
                        decoration: InputDecoration(
                          hintText: 'ani',
                          hintStyle: AppTextStyle.inputHintSmall,
                          fillColor: AppColor.inputFill,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.textPrimary,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama lengkap tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      Text('NIK', style: AppTextStyle.labelMedium),

                      SizedBox(height: 8),

                      TextFormField(
                        controller: controller.nikCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '3512345678909876',
                          hintStyle: AppTextStyle.inputHintSmall,
                          fillColor: AppColor.inputFill,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.textPrimary,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'NIK tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      Text('Email', style: AppTextStyle.labelMedium),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: controller.emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'ani@mail.com',
                          hintStyle: AppTextStyle.inputHintSmall,
                          fillColor: AppColor.inputFill,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.textPrimary,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      Text('No Telpon', style: AppTextStyle.labelMedium),

                      SizedBox(height: 8),

                      TextFormField(
                        controller: controller.noTelponCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '08123456789',
                          hintStyle: AppTextStyle.inputHintSmall,
                          fillColor: AppColor.inputFill,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.textPrimary,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'No telpon tidak boleh kosong';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      Text('Password', style: AppTextStyle.labelMedium),

                      SizedBox(height: 8),

                      Obx(
                        () => TextFormField(
                          controller: controller.passwordCtrl,
                          obscureText: controller.isPassword.value,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: AppTextStyle.inputHintSmall,
                            fillColor: AppColor.inputFill,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColor.inputIcon,
                                size: 18,
                              ),
                              onPressed: controller.toggleShowPassword,
                            ),
                          ),
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.textPrimary,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            if (value.length < 6) {
                              return 'Password minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: 16),

                      Text('Confirm Password', style: AppTextStyle.labelMedium),

                      SizedBox(height: 8),

                      Obx(
                        () => TextFormField(
                          controller: controller.confirmPasswordCtrl,
                          obscureText: controller.isConfirmPassword.value,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: AppTextStyle.inputHintSmall,
                            fillColor: AppColor.inputFill,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isConfirmPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColor.inputIcon,
                                size: 18,
                              ),
                              onPressed: controller.toggleShowConfirmPassword,
                            ),
                          ),
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.textPrimary,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Konfirmasi password tidak boleh kosong';
                            }
                            if (value != controller.passwordCtrl.text) {
                              return 'Password tidak cocok';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: 16),

                      Text('Jenis Kelamin', style: AppTextStyle.labelMedium),

                      SizedBox(height: 8),

                      Obx(
                        () => DropdownButtonFormField<String>(
                          initialValue: controller.selectedJenisKelamin.value,
                          items: controller.jenisKelaminOptions
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: AppTextStyle.bodySmall.copyWith(
                                      color: AppColor.textPrimary,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            controller.selectedJenisKelamin.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Pilih jenis kelamin',
                            hintStyle: AppTextStyle.inputHintSmall,
                            fillColor: AppColor.inputFill,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jenis kelamin harus dipilih';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        'Pilih Rumah yang Sudah Ada',
                        style: AppTextStyle.labelMedium,
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Kalau tidak ada di daftar, silakan isi alamat rumah di bawah ini',
                        style: AppTextStyle.caption.copyWith(
                          color: AppColor.textTertiary,
                        ),
                      ),

                      SizedBox(height: 8),

                      Obx(
                        () => DropdownButtonFormField<String>(
                          initialValue: controller.selectedRumah.value,
                          items: controller.rumaOptions
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: AppTextStyle.bodySmall.copyWith(
                                      color: AppColor.textPrimary,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            controller.selectedRumah.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Rumah Ina',
                            hintStyle: AppTextStyle.inputHintSmall,
                            fillColor: AppColor.inputFill,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        'Alamat Rumah (Jika Tidak Ada di Daftar)',
                        style: AppTextStyle.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.alamatRumahCtrl,
                        decoration: InputDecoration(
                          hintText: 'Blok 5A / No. 10',
                          hintStyle: AppTextStyle.inputHintSmall,
                          fillColor: AppColor.inputFill,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.textPrimary,
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        'Status kepemilikan rumah',
                        style: AppTextStyle.labelMedium,
                      ),

                      SizedBox(height: 8),

                      Obx(
                        () => DropdownButtonFormField<String>(
                          initialValue: controller.selectedStatusRumah.value,
                          items: controller.statusRumahOptions
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: AppTextStyle.bodySmall.copyWith(
                                      color: AppColor.textPrimary,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            controller.selectedStatusRumah.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Pemilik',
                            hintStyle: AppTextStyle.inputHintSmall,
                            fillColor: AppColor.inputFill,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Status kepemilikan harus dipilih';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: 16),

                      Text('Foto Identitas', style: AppTextStyle.labelMedium),

                      SizedBox(height: 8),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.inputFill,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.inputBorder),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 16,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 32,
                              color: AppColor.textHint,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Unggah foto KK/KTP',
                              style: AppTextStyle.bodySmall.copyWith(
                                color: AppColor.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: controller.register,
                          child: Text(
                            'Buat Akun',
                            style: AppTextStyle.titleMedium.copyWith(
                              color: AppColor.textOnPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah Punya akun? ',
                            style: AppTextStyle.bodySmall,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.offNamed(Routes.loginRoute);
                            },
                            child: Text(
                              'Masuk',
                              style: AppTextStyle.bodySmall.copyWith(
                                color: AppColor.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
