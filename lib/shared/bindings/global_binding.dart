import 'dart:developer';

import 'package:get/get.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';
import 'package:jawara_mobile/shared/controllers/global_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GlobalController>(GlobalController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    log('GlobalBinding initialized', name: 'GlobalBinding');
  }
}
