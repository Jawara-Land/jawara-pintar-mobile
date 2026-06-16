import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/page.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/configs/theme/app_theme.dart';
import 'package:jawara_mobile/shared/bindings/global_binding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jawara_mobile/firebase_options.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  SentryWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SentryFlutter.init((options) {
    options.dsn = const String.fromEnvironment('SENTRY_DSN');
    options.tracesSampleRate = 0.2;
  }, appRunner: () => runApp(SentryWidget(child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jawara Pintar',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialBinding: GlobalBinding(),
      initialRoute: Routes.splashRoute,
      getPages: Pages.page,
    );
  }
}
