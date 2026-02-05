import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/announcement/bindings/announcement_binding.dart';
import 'package:jawara_mobile/modules/features/announcement/view/ui/announcement_screen.dart';
import 'package:jawara_mobile/modules/features/aspiration/bindings/aspiration_binding.dart';
import 'package:jawara_mobile/modules/features/aspiration/view/ui/aspiration_screen.dart';
import 'package:jawara_mobile/modules/features/home/bindings/home_binding.dart';
import 'package:jawara_mobile/modules/features/home/view/ui/home_screen.dart';
import 'package:jawara_mobile/modules/features/login/bindings/login_binding.dart';
import 'package:jawara_mobile/modules/features/login/view/ui/login_screen.dart';
import 'package:jawara_mobile/modules/features/main/bindings/main_binding.dart';
import 'package:jawara_mobile/modules/features/main/view/ui/main_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/bindings/marketplace_binding.dart';
import 'package:jawara_mobile/modules/features/marketplace/view/ui/marketplace_screen.dart';
import 'package:jawara_mobile/modules/features/onboarding/bindings/onboarding_binding.dart';
import 'package:jawara_mobile/modules/features/onboarding/views/ui/onboarding_screen.dart';
import 'package:jawara_mobile/modules/features/profile/bindings/profile_binding.dart';
import 'package:jawara_mobile/modules/features/profile/view/ui/profile_screen.dart';
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
      // middlewares: [AuthMiddleware()],
    ),
  ];
}
