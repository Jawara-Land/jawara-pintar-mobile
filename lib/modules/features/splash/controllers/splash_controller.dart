import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 1500)).then((_) {
      Get.offAllNamed(Routes.mainRoute);
    });
  }
}
