import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Widget? child;

  const SectionTitle({
    super.key,
    required this.title,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.headingMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (child != null) ...[
          const SizedBox(height: 16),
          child!,
        ],
      ],
    );
  }
}
