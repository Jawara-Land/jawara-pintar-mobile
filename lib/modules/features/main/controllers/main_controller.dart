import 'package:get/get.dart';

class MainController extends GetxController {
  static MainController get to => Get.find();

  var currentIndex = 0.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
  
}
