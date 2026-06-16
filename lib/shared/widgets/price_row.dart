import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/currency_text.dart';

class PriceRow extends StatelessWidget {
  const PriceRow({
    super.key,
    required this.label,
    required this.amount,
    this.labelStyle,
    this.amountStyle,
  });

  final String label;
  final int amount;
  final TextStyle? labelStyle;
  final TextStyle? amountStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle ?? AppTextStyle.bodyMedium),
        CurrencyText(amount, style: amountStyle ?? AppTextStyle.labelLarge),
      ],
    );
  }
}
