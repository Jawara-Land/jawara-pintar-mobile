import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class QuickActionItem {
  const QuickActionItem({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
}

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({
    super.key,
    required this.items,
    this.crossAxisCount = 4,
    this.childAspectRatio = 0.88,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 8,
    this.iconSize = 32,
    this.circleSize = 70,
  });

  final List<QuickActionItem> items;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double iconSize;
  final double circleSize;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(circleSize / 2),
            onTap: item.onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.primaryLight,
                  ),
                  child: Icon(
                    item.icon,
                    color: AppColor.primary,
                    size: iconSize,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.labelSmall.copyWith(
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class QuickActionRow extends StatelessWidget {
  const QuickActionRow({
    super.key,
    required this.items,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.padding = 12.0,
  });

  final List<QuickActionItem> items;
  final MainAxisAlignment mainAxisAlignment;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: items.map((item) {
        return InkWell(
          onTap: item.onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.primaryLight,
                  child: Icon(item.icon, color: AppColor.primary),
                ),

                SizedBox(height: 4),

                Text(
                  item.label,
                  style: AppTextStyle.labelSmall.copyWith(
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
