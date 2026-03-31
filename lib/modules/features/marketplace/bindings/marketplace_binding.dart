import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/marketplace/controllers/marketplace_controller.dart';

class MarketplaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MarketplaceController());
  }
}
