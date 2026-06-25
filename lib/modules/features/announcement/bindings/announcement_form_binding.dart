import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/announcement/controllers/announcement_form_controller.dart';

class AnnouncementFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnnouncementFormController());
  }
}
