import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/main/controllers/main_controller.dart';
import 'package:jawara_mobile/modules/features/home/bindings/home_binding.dart';
import 'package:jawara_mobile/modules/features/announcement/bindings/announcement_binding.dart';
import 'package:jawara_mobile/modules/features/aspiration/bindings/aspiration_binding.dart';
import 'package:jawara_mobile/modules/features/profile/bindings/profile_binding.dart';
import 'package:jawara_mobile/modules/features/app_notification/controllers/app_notification_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(AppNotificationController());

    HomeBinding().dependencies();
    AnnouncementBinding().dependencies();
    AspirationBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
