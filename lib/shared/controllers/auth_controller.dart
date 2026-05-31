import 'dart:developer';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/login/models/user_model.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  bool get isAuthenticated => currentUser.value != null;

  void setUser(UserModel user) {
    currentUser.value = user;
    log(
      'AuthController: User set — ${user.name} (${user.email})',
      name: 'Auth',
    );
  }

  void clearUser() {
    currentUser.value = null;
    log('AuthController: User cleared', name: 'Auth');
  }

  Future<bool> checkAuthOnStartup() async {
    try {
      final isLoggedIn = await ApiService.isLoggedIn();
      if (!isLoggedIn) return false;

      final result = await ApiService.getUser();
      if (result['success'] == true && result['data'] != null) {
        final user = UserModel.fromJson(
          result['data']['user'] as Map<String, dynamic>,
          permissionsJson: result['data']['permissions'] as Map<String, dynamic>?,
        );
        setUser(user);
        return true;
      } else {
        await ApiService.clearToken();
        clearUser();
        return false;
      }
    } catch (e) {
      log('AuthController: checkAuthOnStartup error — $e', name: 'Auth');
      await ApiService.clearToken();
      clearUser();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.logout();
    } catch (e) {
      log('AuthController: logout API error — $e', name: 'Auth');
      await ApiService.clearToken();
    }
    clearUser();
    Get.offAllNamed(Routes.loginRoute);
  }

  Future<void> logoutAll() async {
    try {
      await ApiService.logoutAll();
    } catch (e) {
      log('AuthController: logoutAll API error — $e', name: 'Auth');
      await ApiService.clearToken();
    }
    clearUser();
    Get.offAllNamed(Routes.loginRoute);
  }
}
