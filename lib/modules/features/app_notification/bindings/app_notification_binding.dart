import 'package:get/get.dart';
import '../controllers/app_notification_controller.dart';

class AppNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppNotificationController>(() => AppNotificationController());
  }
}
