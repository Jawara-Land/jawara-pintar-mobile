import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

/// Badge widget displaying order status with color-coded background
class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
    required this.label,
  });

  final String status;
  final String label;

  Color _getStatusColor() {
    switch (status) {
      case 'pending':
        return AppColor.statusPending;
      case 'paid':
        return AppColor.statusPaid;
      case 'processed':
        return AppColor.statusProcessed;
      case 'shipped':
      case 'picked_up':
        return AppColor.statusShipped;
      case 'completed':
        return AppColor.success;
      case 'cancelled':
        return AppColor.error;
      default:
        return AppColor.textTertiary;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'paid':
        return Icons.payment_rounded;
      case 'processed':
        return Icons.sync_rounded;
      case 'shipped':
      case 'picked_up':
        return Icons.local_shipping_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20), // pill-shaped
        border: Border.all(color: statusColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: statusColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyle.caption.copyWith(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
