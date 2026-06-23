import 'package:get/get.dart';
import '../controllers/transfer_channel_controller.dart';
import '../controllers/transfer_channel_form_controller.dart';

class TransferChannelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferChannelController>(() => TransferChannelController());
  }
}

class TransferChannelFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransferChannelController>(
      () => TransferChannelController(),
      fenix: true,
    );
    Get.lazyPut<TransferChannelFormController>(
      () => TransferChannelFormController(),
    );
  }
}
