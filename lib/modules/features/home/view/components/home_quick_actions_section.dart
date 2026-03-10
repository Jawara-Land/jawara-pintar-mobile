import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class HomeQuickActionsSection extends StatelessWidget {
  const HomeQuickActionsSection({super.key, required this.actions});

  final List<HomeQuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.88,
          mainAxisSpacing: 12,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) => actions[index],
      ),
    );
  }
}

class HomeQuickAction extends StatelessWidget {
  const HomeQuickAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primarySurface,
              ),
              child: Icon(icon, color: AppColor.primary, size: 32),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyle.labelSmall.copyWith(
                color: AppColor.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
