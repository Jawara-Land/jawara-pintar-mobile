import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/splash/constants/splash_assets_constant.dart';
import 'package:jawara_mobile/modules/features/splash/controllers/splash_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  SplashAssetsConstant.appLogo,
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.location_city,
                    size: 50,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Jawara Pintar',
              style: AppTextStyle.displayMedium.copyWith(
                color: AppColor.textOnPrimary,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Sistem Informasi Perumahan Jawara Land',
              style: AppTextStyle.bodyLarge.copyWith(
                color: AppColor.textOnPrimary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 48),

            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: AppColor.onPrimary,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
