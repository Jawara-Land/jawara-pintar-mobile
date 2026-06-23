import 'package:get/get.dart';
import '../controllers/log_history_controller.dart';

class LogHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogHistoryController>(() => LogHistoryController());
  }
}
