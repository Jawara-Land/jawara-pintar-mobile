import 'package:flutter/material.dart';
import 'package:jawara_mobile/modules/features/onboarding/constants/onboarding_assets_constant.dart';
import 'package:jawara_mobile/modules/features/onboarding/models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          data.backgroundImage ?? OnboardingAssetsConstant.initialBackground,
          fit: BoxFit.cover,
        ),
        Container(color: Colors.black.withOpacity(0.5)),
      ],
    );
  }
}
