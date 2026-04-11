import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();
  @override
  void onInit() {
    super.onInit();
    Get.log('SplashController is initialized. Checking authentication status...');
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final results = await Future.wait([
        AuthController.to.checkAuthOnStartup(),
        Future.delayed(const Duration(milliseconds: 1500)),
      ]);

      final isAuthenticated = results[0] as bool;

      if (isAuthenticated) {
        Get.offAllNamed(Routes.mainRoute);
      } else {
        Get.offAllNamed(Routes.onboardingRoute);
      }
    } catch (e) {
      Get.log('SplashController: _checkAuth error — $e');
      Get.offAllNamed(Routes.onboardingRoute);
    }
  }
}
