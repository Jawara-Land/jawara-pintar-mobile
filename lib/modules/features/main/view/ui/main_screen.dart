import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/announcement/view/ui/announcement_screen.dart';
import 'package:jawara_mobile/modules/features/aspiration/view/ui/aspiration_screen.dart';
import 'package:jawara_mobile/modules/features/home/view/components/home_dashboard_view.dart';
import 'package:jawara_mobile/modules/features/main/controllers/main_controller.dart';
import 'package:jawara_mobile/modules/features/main/view/widgets/main_bottom_navigation.dart';
import 'package:jawara_mobile/modules/features/profile/view/ui/profile_screen.dart';

class MainScreen extends GetView<MainController> {
  MainScreen({super.key});

  final List<Widget> mainScreens = [
    HomeDashboardView(),
    AnnouncementScreen(),
    AspirationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => mainScreens[controller.currentIndex.value]),

      bottomNavigationBar: Obx(
        () => MainBottomNavigation(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTabIndex,
        ),
      ),
    );
  }
}
