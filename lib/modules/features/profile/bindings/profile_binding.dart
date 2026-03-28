import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/profile/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
