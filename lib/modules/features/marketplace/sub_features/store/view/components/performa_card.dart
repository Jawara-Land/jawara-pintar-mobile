import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class PerformaCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final Color? backgroundColor;

  const PerformaCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.backgroundColor,
  });

  /// Factory constructor for revenue performa card
  factory PerformaCard.revenue({
    Key? key,
    required int totalRevenue,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return PerformaCard(
      key: key,
      icon: Icons.trending_up,
      label: 'Pendapatan',
      value: _formatCurrency(totalRevenue),
      iconColor: iconColor,
      backgroundColor: backgroundColor,
    );
  }

  /// Factory constructor for total orders performa card
  factory PerformaCard.totalOrders({
    Key? key,
    required int totalOrders,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return PerformaCard(
      key: key,
      icon: Icons.shopping_cart_outlined,
      label: 'Total Pesanan',
      value: totalOrders.toString(),
      iconColor: iconColor,
      backgroundColor: backgroundColor,
    );
  }

  /// Factory constructor for pending orders performa card
  factory PerformaCard.pendingOrders({
    Key? key,
    required int pendingOrders,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return PerformaCard(
      key: key,
      icon: Icons.pending_actions_outlined,
      label: 'Menunggu',
      value: pendingOrders.toString(),
      iconColor: iconColor ?? AppColor.warning,
      backgroundColor: backgroundColor,
    );
  }

  /// Factory constructor for completed orders performa card
  factory PerformaCard.completedOrders({
    Key? key,
    required int completedOrders,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return PerformaCard(
      key: key,
      icon: Icons.check_circle_outline,
      label: 'Selesai',
      value: completedOrders.toString(),
      iconColor: iconColor ?? AppColor.success,
      backgroundColor: backgroundColor,
    );
  }

  static String _formatCurrency(int amount) {
    String result = amount.toString();
    String formatted = '';
    int count = 0;

    for (int i = result.length - 1; i >= 0; i--) {
      count++;
      formatted = result[i] + formatted;
      if (count % 3 == 0 && i != 0) {
        formatted = '.$formatted';
      }
    }

    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColor.border.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: iconColor ?? AppColor.primary),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyle.bodyMedium.copyWith(color: AppColor.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyle.headingMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
