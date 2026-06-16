import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';


class BadgeCount extends StatelessWidget {
  const BadgeCount({
    super.key,
    required this.count,
    required this.child,
    this.size = 16,
    this.fontSize = 10,
    this.borderRadius = 10,
  });

  final int count;
  final Widget child;
  final double size;
  final double fontSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return child;

    return Stack(
      children: [
        child,
        Positioned(
          right: 4,
          top: 4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColor.error,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            constraints: BoxConstraints(
              minWidth: size,
              minHeight: size,
            ),
            child: Text(
              '$count',
              style: AppTextStyle.caption.copyWith(
                color: AppColor.textOnPrimary,
                fontSize: fontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
