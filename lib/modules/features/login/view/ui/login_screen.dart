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

                        Text('Email', style: AppTextStyle.headingSmall),

                        SizedBox(height: 8),

                        TextFormField(
                          controller: controller.emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            controller.emailValue.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'admin@mail.com',
                            hintStyle: AppTextStyle.inputHint,
                            filled: true,
                            fillColor: AppColor.inputFill,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColor.inputBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColor.primary,
                                width: 1.5,
                              ),
                            ),
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

                        SizedBox(height: 20),

                        Text('Password', style: AppTextStyle.headingSmall),

                        SizedBox(height: 8),

                        TextFormField(
                          controller: controller.passwordCtrl,
                          obscureText: controller.isPassword.value,
                          onChanged: (value) {
                            controller.passwordValue.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: AppTextStyle.inputHint,
                            filled: true,
                            fillColor: AppColor.inputFill,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColor.inputBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColor.primary,
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
                              onPressed: controller.toogleShowPassword,
                            ),
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

                        SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                            ),
                            onPressed: () => Get.offNamed(Routes.mainRoute),
                            child: Text(
                              'Login',
                              style: AppTextStyle.headingMedium.copyWith(
                                color: AppColor.textOnPrimary,
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
