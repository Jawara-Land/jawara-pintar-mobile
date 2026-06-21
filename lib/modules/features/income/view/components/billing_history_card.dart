import 'package:flutter/material.dart';
import 'package:jawara_mobile/modules/features/income/models/bill_history_group_model.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/currency_text.dart';

class BillingHistoryCard extends StatelessWidget {
  const BillingHistoryCard({required this.group, super.key});

  final BillHistoryGroupModel group;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kode: ${group.code}',
                style: AppTextStyle.titleLarge.copyWith(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: AppColor.textTertiary,
                  ),
                  
                  SizedBox(width: 4),

                  Text(
                    group.period,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 8),

          Text(
            'Kategori: ${group.categoryName}',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.textSecondary,
            ),
          ),
          
          Divider(height: 24, color: AppColor.border),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status & Target',
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.textTertiary,
                    ),
                  ),
                  
                  SizedBox(height: 2),

                  Text(
                    '${group.recordStatus} • ${group.totalFamilies} keluarga',
                    style: AppTextStyle.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Tagihan',
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.textTertiary,
                    ),
                  ),
                  
                  SizedBox(height: 2),
                  
                  CurrencyText(
                    group.amount,
                    style: AppTextStyle.titleMedium.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
