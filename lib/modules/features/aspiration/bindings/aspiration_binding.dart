import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/aspiration/controllers/aspiration_controller.dart';

class AspirationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AspirationController>()) {
      Get.lazyPut<AspirationController>(() => AspirationController());
    }
  }
}
