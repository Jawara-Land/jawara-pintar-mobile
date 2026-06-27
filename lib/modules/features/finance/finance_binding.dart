import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/finance/finance_controller.dart';

class FinanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinanceController>(() => FinanceController());
  }
}
