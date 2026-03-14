import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/announcement/controllers/announcement_controller.dart';

class AnnouncementBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AnnouncementController());
  }
}
