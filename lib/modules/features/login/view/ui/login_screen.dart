import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/login/constants/login_assets_constant.dart';
import 'package:jawara_mobile/modules/features/login/controllers/login_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 44,
                  bottom: 0,
                  left: 30,
                  right: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          LoginAssetsConstant.appLogo,
                          width: 55,
                          height: 55,
                        ),

                        const SizedBox(width: 12),

                        Text(
                          'Jawara Pintar',
                          style: AppTextStyle.displayMedium,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Text(
                      'Selamat Datang',
                      style: AppTextStyle.displayLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Login untuk mengakses sistem\nJawara Pintar',
                      style: AppTextStyle.headingMedium.copyWith(
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
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
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Masuk ke akun anda',
                            style: AppTextStyle.displaySmall,
                          ),
                        ),

                        SizedBox(height: 24),

                        Obx(() {
                          if (controller.errorMessage.value.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColor.errorLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColor.error.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColor.errorDark,
                                  size: 20,
                                ),

                                SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    controller.errorMessage.value,
                                    style: AppTextStyle.bodyMedium.copyWith(
                                      color: AppColor.errorDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        Text('Email', style: AppTextStyle.headingSmall),

                        SizedBox(height: 8),

                        Obx(
                          () => TextFormField(
                            controller: controller.emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            enabled: !controller.isLoading.value,
                            onChanged: (value) {
                              controller.emailValue.value = value;

                              if (controller.emailError.value.isNotEmpty) {
                                controller.emailError.value = '';
                              }
                              if (controller.errorMessage.value.isNotEmpty) {
                                controller.errorMessage.value = '';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'admin@mail.com',
                              hintStyle: AppTextStyle.inputHint,
                              filled: true,
                              fillColor: controller.isLoading.value
                                  ? AppColor.inputFillDisabled
                                  : AppColor.inputFill,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: controller.emailError.value.isNotEmpty
                                      ? AppColor.error.withValues(alpha: 0.6)
                                      : AppColor.inputBorder,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: controller.emailError.value.isNotEmpty
                                      ? AppColor.error
                                      : AppColor.primary,
                                  width: 1.5,
                                ),
                              ),

                              errorText: controller.emailError.value.isNotEmpty
                                  ? controller.emailError.value
                                  : null,
                            ),
                            style: AppTextStyle.bodyMedium,
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
                        ),

                        SizedBox(height: 20),

                        Text('Password', style: AppTextStyle.headingSmall),

                        SizedBox(height: 8),

                        Obx(
                          () => TextFormField(
                            controller: controller.passwordCtrl,
                            obscureText: controller.isPassword.value,
                            enabled: !controller.isLoading.value,
                            onChanged: (value) {
                              controller.passwordValue.value = value;

                              if (controller.passwordError.value.isNotEmpty) {
                                controller.passwordError.value = '';
                              }
                              if (controller.errorMessage.value.isNotEmpty) {
                                controller.errorMessage.value = '';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: AppTextStyle.inputHint,
                              filled: true,
                              fillColor: controller.isLoading.value
                                  ? AppColor.inputFillDisabled
                                  : AppColor.inputFill,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color:
                                      controller.passwordError.value.isNotEmpty
                                      ? AppColor.error.withValues(alpha: 0.6)
                                      : AppColor.inputBorder,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color:
                                      controller.passwordError.value.isNotEmpty
                                      ? AppColor.error
                                      : AppColor.primary,
                                  width: 1.5,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColor.inputIcon,
                                ),
                                onPressed: controller.isLoading.value
                                    ? null
                                    : controller.toogleShowPassword,
                              ),

                              errorText:
                                  controller.passwordError.value.isNotEmpty
                                  ? controller.passwordError.value
                                  : null,
                            ),
                            style: AppTextStyle.bodyMedium,
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

                        SizedBox(height: 24),

                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isLoading.value
                                    ? AppColor.primary.withValues(alpha: 0.7)
                                    : AppColor.primary,
                              ),
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.login(),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: AppColor.onPrimary,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'Login',
                                      style: AppTextStyle.headingMedium
                                          .copyWith(
                                            color: AppColor.textOnPrimary,
                                          ),
                                    ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.registerRoute),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Belum Punya akun? ',
                                style: AppTextStyle.headingSmall.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Text(
                                'Daftar',
                                style: AppTextStyle.headingSmall.copyWith(
                                  color: AppColor.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
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
