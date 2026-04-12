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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: AppColor.backgroundAlt),
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 10,
                  left: 30,
                  right: 30,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios, size: 30),
                      color: AppColor.textPrimary,
                    ),

                    Image.asset(
                      RegisterAssetsConstant.appLogo,
                      width: 55,
                      height: 55,
                    ),

                    SizedBox(width: 12),

                    Text('Jawara Pintar', style: AppTextStyle.displayMedium),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 16,
                ),
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
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Daftar Akun', style: AppTextStyle.displaySmall),

                        SizedBox(height: 4),

                        Text(
                          'Lengkapi formulir untuk membuat akun',
                          style: AppTextStyle.bodyLarge.copyWith(
                            color: AppColor.textTertiary,
                          ),
                        ),

                        SizedBox(height: 24),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Lengkap',
                              style: AppTextStyle.headingSmall,
                            ),

                            SizedBox(height: 8),

                            TextFormField(
                              controller: controller.namaLengkapCtrl,
                              decoration: InputDecoration(
                                hintText: 'ani',
                                hintStyle: AppTextStyle.inputHintLarge,
                                fillColor: AppColor.inputFill,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                              style: AppTextStyle.bodyLarge.copyWith(
                                color: AppColor.textPrimary,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama lengkap tidak boleh kosong';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16),

                            Text('NIK', style: AppTextStyle.headingSmall),

                            SizedBox(height: 8),

                            TextFormField(
                              controller: controller.nikCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '3512345678909876',
                                hintStyle: AppTextStyle.inputHintLarge,
                                fillColor: AppColor.inputFill,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                              style: AppTextStyle.bodyLarge.copyWith(
                                color: AppColor.textPrimary,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'NIK tidak boleh kosong';
                                }
                                if (value.length != 16) {
                                  return 'NIK harus terdiri dari 16 digit';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16),

                            Text('Email', style: AppTextStyle.headingSmall),

                            SizedBox(height: 8),

                            TextFormField(
                              controller: controller.emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'ani@mail.com',
                                hintStyle: AppTextStyle.inputHintLarge,
                                fillColor: AppColor.inputFill,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                              style: AppTextStyle.bodyLarge.copyWith(
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

                            Text('No Telpon', style: AppTextStyle.headingSmall),

                            SizedBox(height: 8),

                            TextFormField(
                              controller: controller.noTelponCtrl,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '08123456789',
                                hintStyle: AppTextStyle.inputHintLarge,
                                fillColor: AppColor.inputFill,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                              style: AppTextStyle.bodyLarge.copyWith(
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

                            Text('Password', style: AppTextStyle.headingSmall),

                            SizedBox(height: 8),

                            Obx(
                              () => TextFormField(
                                controller: controller.passwordCtrl,
                                obscureText: controller.isPassword.value,
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: AppTextStyle.inputHintLarge,
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
                                style: AppTextStyle.bodyLarge.copyWith(
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

                            Text(
                              'Confirm Password',
                              style: AppTextStyle.headingSmall,
                            ),

                            SizedBox(height: 8),

                            Obx(
                              () => TextFormField(
                                controller: controller.confirmPasswordCtrl,
                                obscureText: controller.isConfirmPassword.value,
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: AppTextStyle.inputHintLarge,
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
                                    onPressed:
                                        controller.toggleShowConfirmPassword,
                                  ),
                                ),
                                style: AppTextStyle.bodyLarge.copyWith(
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

                            Text(
                              'Jenis Kelamin',
                              style: AppTextStyle.headingSmall,
                            ),

                            SizedBox(height: 8),

                            Obx(
                              () => DropdownButtonFormField<String>(
                                initialValue:
                                    controller.selectedJenisKelamin.value,
                                items: controller.jenisKelaminOptions
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: AppTextStyle.bodyLarge
                                              .copyWith(
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

                            Obx(() {
                              if (controller.isLoadingHouses.value) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.inputFill,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColor.inputBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColor.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Memuat daftar rumah...',
                                        style: AppTextStyle.bodySmall.copyWith(
                                          color: AppColor.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return DropdownButtonFormField<int>(
                                initialValue: controller.selectedHouseId.value,
                                items: controller.houses
                                    .map(
                                      (house) => DropdownMenuItem(
                                        value: house.id,
                                        child: Text(
                                          house.address,
                                          style: AppTextStyle.bodyLarge
                                              .copyWith(
                                                color: AppColor.textPrimary,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  controller.selectedHouseId.value = value;
                                },
                                decoration: InputDecoration(
                                  hintText: controller.houses.isEmpty
                                      ? 'Tidak ada rumah tersedia'
                                      : 'Pilih rumah',
                                  hintStyle: AppTextStyle.inputHintSmall,
                                  fillColor: AppColor.inputFill,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                ),
                                isExpanded: true,
                              );
                            }),

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
                                initialValue:
                                    controller.selectedStatusRumah.value,
                                items: controller.statusRumahOptions
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: AppTextStyle.bodyLarge
                                              .copyWith(
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

                            Text(
                              'Foto Identitas',
                              style: AppTextStyle.labelMedium,
                            ),

                            SizedBox(height: 8),

                            Obx(
                              () => GestureDetector(
                                onTap: controller.pickKtpImage,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColor.inputFill,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColor.inputBorder,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child:
                                      controller.selectedKtpImage.value != null
                                      ? Stack(
                                          children: [
                                            Image.file(
                                              controller
                                                  .selectedKtpImage
                                                  .value!,
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: GestureDetector(
                                                onTap:
                                                    controller.removeKtpImage,
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Padding(
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
                                                style: AppTextStyle.bodyLarge
                                                    .copyWith(
                                                      color:
                                                          AppColor.textTertiary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            SizedBox(height: 24),

                            Obx(() {
                              if (controller.errorMessage.value.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.red.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red.shade700,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          controller.errorMessage.value,
                                          style: AppTextStyle.bodySmall
                                              .copyWith(
                                                color: Colors.red.shade700,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            SizedBox(
                              width: double.infinity,
                              child: Obx(
                                () => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.register,
                                  child: controller.isLoading.value
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColor.textOnPrimary,
                                          ),
                                        )
                                      : Text(
                                          'Buat Akun',
                                          style: AppTextStyle.titleMedium
                                              .copyWith(
                                                color: AppColor.textOnPrimary,
                                                fontWeight: FontWeight.w600,
                                              ),
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
                                  style: AppTextStyle.bodyLarge,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.offNamed(Routes.loginRoute);
                                  },
                                  child: Text(
                                    'Masuk',
                                    style: AppTextStyle.bodyLarge.copyWith(
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
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
