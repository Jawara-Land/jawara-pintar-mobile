import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class HomeAnalyticsSection extends StatelessWidget {
  const HomeAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _analyticsItems.take(3).length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          mainAxisSpacing: 14,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final item = _analyticsItems[index];
          return HomeAnalyticsCard(
            title: item.title,
            value: item.value,
            icon: item.icon,
          );
        },
      ),
    );
  }
}

class HomeAnalyticsCard extends StatelessWidget {
  const HomeAnalyticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.titleLarge.copyWith(
              color: AppColor.textSecondary,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyle.analyticsValue,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColor.textPrimary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsItem {
  const _AnalyticsItem(this.title, this.value, this.icon);

  final String title;
  final String value;
  final IconData icon;
}

const List<_AnalyticsItem> _analyticsItems = [
  _AnalyticsItem('Total Keluarga', '35', Icons.groups_2),
  _AnalyticsItem('Total Kegiatan', '5', Icons.groups),
  _AnalyticsItem('Total Pemasukan', '5.JT', Icons.account_balance_wallet),
];
