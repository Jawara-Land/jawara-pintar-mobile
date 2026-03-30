import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class MainBottomNavigation extends StatelessWidget {
  const MainBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      _MainNavItem(icon: Icons.home, label: 'Beranda'),
      _MainNavItem(icon: Icons.campaign, label: 'Pengumuman'),
      _MainNavItem(icon: Icons.chat_bubble_outline, label: 'Pesan'),
      _MainNavItem(icon: Icons.person_outline, label: 'Profil'),
    ];

    return Material(
      elevation: 8,
      color: AppColor.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 3,
                          width: isSelected ? 72 : 0,
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),

                        SizedBox(height: 10),

                        Icon(
                          item.icon,
                          color: isSelected
                              ? AppColor.primary
                              : AppColor.textHint,
                          size: 28,
                        ),

                        SizedBox(height: 4),

                        Text(
                          item.label,
                          style: AppTextStyle.caption.copyWith(
                            color: isSelected
                                ? AppColor.primary
                                : AppColor.textHint,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _MainNavItem {
  const _MainNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
