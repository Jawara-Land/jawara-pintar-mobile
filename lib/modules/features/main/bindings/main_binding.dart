import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/main/controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
  }
}
