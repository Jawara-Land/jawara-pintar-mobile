import 'package:flutter/material.dart';
import 'package:jawara_mobile/modules/features/home/view/components/home_dashboard_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: HomeDashboardView()),
    );
  }
}
