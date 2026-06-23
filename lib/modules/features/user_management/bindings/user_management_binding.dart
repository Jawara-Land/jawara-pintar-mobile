import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/user_management/controllers/user_management_controller.dart';
import 'package:jawara_mobile/modules/features/user_management/controllers/user_management_form_controller.dart';

class UserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManagementController>(() => UserManagementController());
  }
}

class UserManagementFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManagementFormController>(() => UserManagementFormController(),
    );
  }
}
