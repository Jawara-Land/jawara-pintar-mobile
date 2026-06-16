import 'package:flutter/material.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/models/order_model.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final String status;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.status,
    this.onTap,
  });

  /// Factory constructor from OrderModel
  factory OrderCard.fromOrder({
    Key? key,
    required OrderModel order,
    VoidCallback? onTap,
  }) {
    final dateStr = order.createdAt != null
        ? '${order.createdAt!.day} ${_getMonthShort(order.createdAt!.month)}'
        : '';

    return OrderCard(
      key: key,
      orderId: '#${order.orderNumber}',
      date: dateStr,
      status: order.statusLabel,
      onTap: onTap,
    );
  }

  static String _getMonthShort(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'menunggu':
        return AppColor.warning;
      case 'processing':
      case 'diproses':
      case 'dikemas':
        return AppColor.info;
      case 'shipped':
      case 'dikirim':
      case 'dalam pengiriman':
        return AppColor.primary;
      case 'completed':
      case 'selesai':
        return AppColor.success;
      case 'cancelled':
      case 'dibatalkan':
        return AppColor.error;
      default:
        return AppColor.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColor.border.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order $orderId',
                      style: AppTextStyle.headingMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status,
                            style: AppTextStyle.bodySmall.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style: AppTextStyle.headingSmall.copyWith(color: AppColor.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
