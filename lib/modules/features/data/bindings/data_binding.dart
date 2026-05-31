import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/data/controllers/data_controller.dart';

class DataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataController>(() => DataController());
  }
}
