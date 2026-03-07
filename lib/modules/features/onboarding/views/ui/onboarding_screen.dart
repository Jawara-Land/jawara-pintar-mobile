import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/onboarding/controllers/onboarding_controller.dart';
import 'package:jawara_mobile/modules/features/onboarding/views/components/onboarding_page.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: controller.onboardingPages.length,
            itemBuilder: (context, index) {
              final page = controller.onboardingPages[index];
              return OnboardingPage(data: page);
            },
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: Obx(
              () =>
                  controller.currentPage.value <
                      controller.onboardingPages.length - 1
                  ? TextButton(
                      onPressed: controller.skipOnboarding,
                      child: Text(
                        'Lewati',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.textOnPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() {
              final page =
                  controller.onboardingPages[controller.currentPage.value];
              final isLastPage =
                  controller.currentPage.value ==
                  controller.onboardingPages.length - 1;
              return Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, isLastPage ? 180 : 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      page.title,
                      style: Get.textTheme.displayMedium?.copyWith(
                        color: AppColor.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      page.description,
                      style: AppTextStyle.headingSmall.copyWith(
                        color: AppColor.textOnPrimary.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                30,
                32,
                30,
                MediaQuery.of(context).padding.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    final isLastPage =
                        controller.currentPage.value ==
                        controller.onboardingPages.length - 1;

                    if (isLastPage) {
                      return SizedBox.shrink();
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.onboardingPages.length,
                        (index) => Container(
                          height: 8,
                          width: controller.currentPage.value == index ? 24 : 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? AppColor.primary
                                : AppColor.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 32),

                  Obx(() {
                    final isLastPage =
                        controller.currentPage.value ==
                        controller.onboardingPages.length - 1;
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: controller.nextPage,
                            child: Text(
                              isLastPage ? 'Masuk' : 'Lanjut',
                              style: AppTextStyle.bodyLarge.copyWith(
                                color: AppColor.textOnPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  Obx(() {
                    final isLastPage =
                        controller.currentPage.value ==
                        controller.onboardingPages.length - 1;
                    if (isLastPage) {
                      return GestureDetector(
                        onTap: () => Get.toNamed(Routes.registerRoute),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun? ',
                              style: AppTextStyle.bodyLarge.copyWith(
                                color: AppColor.textOnPrimary,
                              ),
                            ),
                            Text(
                              'Daftar',
                              style: AppTextStyle.bodyLarge.copyWith(
                                color: AppColor.textOnPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
