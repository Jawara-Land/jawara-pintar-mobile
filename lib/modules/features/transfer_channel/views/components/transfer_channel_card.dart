import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import '../../models/transfer_channel_model.dart';

class TransferChannelCard extends StatelessWidget {
  const TransferChannelCard({
    super.key,
    required this.channel,
    required this.canWrite,
    required this.onEdit,
    required this.onDelete,
  });

  final TransferChannel channel;
  final bool canWrite;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String get _typeLabel {
    switch (channel.type) {
      case 'bank':
        return 'Bank';
      case 'ewallet':
        return 'E-Wallet';
      case 'qris':
        return 'QRIS';
      default:
        return channel.type.toUpperCase();
    }
  }

  Color get _typeColor {
    switch (channel.type) {
      case 'bank':
        return AppColor.info;
      case 'ewallet':
        return AppColor.success;
      case 'qris':
        return AppColor.warning;
      default:
        return AppColor.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.border),
        boxShadow: const [
          BoxShadow(
            color: AppColor.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: channel.thumbnail != null
                  ? Image.network(
                      channel.thumbnail!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, e, s) =>
                          _PlaceholderIcon(type: channel.type),
                    )
                  : _PlaceholderIcon(type: channel.type),
            ),
            
            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          channel.name,
                          style: AppTextStyle.titleMedium,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _typeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _typeLabel,
                          style: AppTextStyle.bodySmall.copyWith(
                            color: _typeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (channel.accountNumber != null &&
                      channel.accountNumber!.isNotEmpty) ...[
                    SizedBox(height: 4),

                    Text(
                      channel.accountNumber!,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                  if (channel.holderName != null &&
                      channel.holderName!.isNotEmpty) ...[
                    SizedBox(height: 2),

                    Text(
                      'a/n ${channel.holderName}',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.textTertiary,
                      ),
                    ),
                  ],
                  if (channel.note != null && channel.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      channel.note!,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.textHint,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            if (canWrite)
              Column(
                children: [
                  InkWell(
                    onTap: onEdit,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.edit_outlined,
                        color: AppColor.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 4),
                  
                  InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        color: AppColor.error,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon({required this.type});

  final String type;

  IconData get _icon {
    switch (type) {
      case 'bank':
        return Icons.account_balance_outlined;
      case 'ewallet':
        return Icons.wallet_outlined;
      case 'qris':
        return Icons.qr_code_2;
      default:
        return Icons.payment_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(_icon, color: AppColor.primary, size: 24),
    );
  }
}
