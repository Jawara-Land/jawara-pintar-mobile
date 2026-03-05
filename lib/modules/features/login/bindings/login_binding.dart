import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
