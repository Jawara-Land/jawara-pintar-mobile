import 'package:flutter/material.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/expense/models/expense_model.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/currency_text.dart';
import 'package:get/get.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({required this.expense, super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('${Routes.expenseDetailRoute}/${expense.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.border),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColor.errorLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    color: AppColor.error,
                    size: 20,
                  ),
                ),
                
                SizedBox(width: 12),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.name,
                        style: AppTextStyle.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (expense.expenseCategory != null) ...[
                        
                        SizedBox(height: 4),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.errorLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            expense.expenseCategory!,
                            style: AppTextStyle.caption.copyWith(
                              color: AppColor.errorDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                SizedBox(width: 8),

                CurrencyText(
                  expense.amount.toInt(),
                  style: AppTextStyle.titleMedium.copyWith(
                    color: AppColor.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12),

            Divider(height: 1, color: AppColor.border),

            SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: AppColor.textTertiary,
                ),
                
                SizedBox(width: 4),

                Text(expense.happenedAt ?? '-', style: AppTextStyle.caption),
                
                Spacer(),

                if (expense.verificator != null) ...[
                  const Icon(
                    Icons.verified_outlined,
                    size: 13,
                    color: AppColor.success,
                  ),
                  
                  SizedBox(width: 4),
                  
                  Text(
                    expense.verificator!,
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.success,
                    ),
                  ),
                ] else
                  Text(
                    'Belum diverifikasi',
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.warning,
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
