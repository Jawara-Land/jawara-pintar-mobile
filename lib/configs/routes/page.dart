import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/login/bindings/login_binding.dart';
import 'package:jawara_mobile/modules/features/login/view/ui/login_screen.dart';
import 'package:jawara_mobile/modules/features/main/bindings/main_binding.dart';
import 'package:jawara_mobile/modules/features/main/view/ui/main_screen.dart';
import 'package:jawara_mobile/modules/features/onboarding/bindings/onboarding_binding.dart';
import 'package:jawara_mobile/modules/features/onboarding/views/ui/onboarding_screen.dart';
import 'package:jawara_mobile/modules/features/register/bindings/register_binding.dart';
import 'package:jawara_mobile/modules/features/register/view/ui/register_screen.dart';
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
    GetPage(
      name: Routes.loginRoute,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.registerRoute,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),
  ];
}
