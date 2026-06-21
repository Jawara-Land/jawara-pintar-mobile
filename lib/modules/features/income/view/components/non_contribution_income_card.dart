import 'package:flutter/material.dart';
import 'package:jawara_mobile/modules/features/income/models/income_non_contribution_model.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/currency_text.dart';

class NonContributionIncomeCard extends StatelessWidget {
  const NonContributionIncomeCard({required this.item, super.key});

  final IncomeNonContributionModel item;

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
              Expanded(
                child: Text(
                  item.name,
                  style: AppTextStyle.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.incomeCategory,
                  style: AppTextStyle.caption.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: AppColor.textTertiary,
              ),
              
              SizedBox(width: 4),

              Text(
                'Tanggal: ${item.happenedAt ?? "-"}',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.textTertiary,
                ),
              ),
            ],
          ),
          
          Divider(height: 24, color: AppColor.border),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nominal',
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.textTertiary,
                    ),
                  ),
                  
                  SizedBox(height: 2),

                  CurrencyText(
                    item.amount,
                    style: AppTextStyle.titleLarge.copyWith(
                      color: AppColor.successDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColor.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColor.successDark,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
