import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/onboarding/constants/onboarding_assets_constant.dart';
import 'package:jawara_mobile/modules/features/onboarding/models/onboarding_model.dart';

class OnboardingController extends GetxController {
  late PageController pageController;
  RxInt currentPage = 0.obs;

  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      title: 'Jawara Pintar',
      description:
          'Solusi digital untuk manajemen keuangan dan kegiatan warga.',
      backgroundImage: OnboardingAssetsConstant.initialBackground,
      buttonLabel: 'Lanjut',
    ),
    OnboardingModel(
      title: 'Kemudahan Administrasi',
      description:
          'Kelola pendataan warga dan publikasi kegiatan dengan lebih cepat langsung dari smartphone.',
      backgroundImage: OnboardingAssetsConstant.initialBackground,
      buttonLabel: 'Lanjut',
    ),
    OnboardingModel(
      title: 'Marketplace Warga',
      description:
          'Mempermudah transaksi jual beli antar warga dan meningkatkan pemberdayaan UMKM lokal.',
      backgroundImage: OnboardingAssetsConstant.initialBackground,
      buttonLabel: 'Lanjut',
    ),
    OnboardingModel(
      title: 'Selamat Datang',
      description: 'Login untuk mengakses sistem Jawara Pintar.',
      backgroundImage: OnboardingAssetsConstant.initialBackground,
      buttonLabel: 'Masuk',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offNamed(Routes.loginRoute);
    }
  }

  void skipOnboarding() {
    pageController.animateToPage(
      onboardingPages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
