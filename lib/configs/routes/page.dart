import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/main/bindings/main_binding.dart';
import 'package:jawara_mobile/modules/features/main/view/ui/main_screen.dart';
import 'package:jawara_mobile/modules/features/onboarding/bindings/onboarding_binding.dart';
import 'package:jawara_mobile/modules/features/onboarding/views/ui/onboarding_screen.dart';
import 'package:jawara_mobile/modules/features/splash/bindings/splash_binding.dart';
import 'package:jawara_mobile/modules/features/splash/view/ui/splash_screen.dart';

abstract class Pages {
  static final page = [
    GetPage(
      name: Routes.splashRoute,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.mainRoute,
      page: () => MainScreen(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.onboardingRoute,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
  ];
}
