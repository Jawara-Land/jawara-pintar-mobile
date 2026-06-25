import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/event/controllers/event_form_controller.dart';

class EventFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EventFormController());
  }
}
