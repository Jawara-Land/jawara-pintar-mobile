import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/page.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/configs/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jawara Pintar',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashRoute,
      getPages: Pages.page,
    );
  }
}
