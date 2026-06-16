import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/constants/app_icons.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class CategoryChip extends StatelessWidget {
  // final int id;
  final String label;
  final String? iconName;
  final bool isSelected;
  final VoidCallback onSelected;

  const CategoryChip({
    super.key,
    // required this.id,
    required this.label,
    this.iconName,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final icon = AppIcons.get(iconName);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        showCheckmark: false,
        avatar: Icon(
          icon,
          key: ValueKey(isSelected),
          size: 18,
          color: isSelected ? Colors.white : AppColor.primary,
        ),
        label: Text(label),
        selected: isSelected,
        backgroundColor: AppColor.primaryLight,
        selectedColor: AppColor.primary,
        tooltip: label,
        labelStyle: AppTextStyle.caption.copyWith(
          color: isSelected ? AppColor.onPrimary : AppColor.textPrimary,
        ),
        onSelected: (_) => onSelected(),
      ),
    );
  }
}
