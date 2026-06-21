import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/income/models/family_contribution_model.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/currency_text.dart';

class TreasurerBillCard extends StatelessWidget {
  const TreasurerBillCard({
    required this.bill,
    required this.onReject,
    required this.onApprove,
    super.key,
  });

  final FamilyContributionModel bill;
  final VoidCallback onReject;
  final VoidCallback onApprove;

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Keluarga: ${bill.familyName}',
                  style: AppTextStyle.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              SizedBox(width: 8),

              _buildStatusBadge(bill.status),
            ],
          ),
          
          SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: AppColor.textTertiary,
              ),
              
              SizedBox(width: 4),

              Expanded(
                child: Text(
                  '${bill.contributionName} • ${bill.billMonth}',
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.textTertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          Divider(height: 24, color: AppColor.border),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    int.tryParse(bill.amount) ?? 0,
                    style: AppTextStyle.titleLarge.copyWith(
                      color: AppColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (bill.isWaitingApproval)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.error,
                        side: const BorderSide(color: AppColor.error),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Tolak'),
                    ),
                    
                    SizedBox(width: 8),

                    ElevatedButton(
                      onPressed: onApprove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.success,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Setujui',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              else if (bill.paymentProof != null)
                OutlinedButton.icon(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text('Bukti Pembayaran'),
                        content: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InteractiveViewer(
                            child: Image.network(
                              bill.paymentProof!.startsWith('http')
                                  ? bill.paymentProof!
                                  : 'http://10.0.2.2:8000/storage/${bill.paymentProof}',
                              errorBuilder: (c, o, s) => const SizedBox(
                                height: 150,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 64,
                                    color: AppColor.textHint,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt_long, size: 16),
                  label: const Text('Bukti'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColor.primary),
                    foregroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    String txt;

    switch (status) {
      case 'approved':
      case 'paid':
        bg = AppColor.success.withValues(alpha: 0.15);
        fg = AppColor.successDark;
        txt = 'Lunas';
        break;
      case 'waiting_approval':
      case 'pending':
        bg = AppColor.warning.withValues(alpha: 0.15);
        fg = AppColor.warningDark;
        txt = 'Menunggu Verifikasi';
        break;
      case 'rejected':
        bg = AppColor.error.withValues(alpha: 0.15);
        fg = AppColor.errorDark;
        txt = 'Ditolak';
        break;
      default:
        bg = AppColor.textHint.withValues(alpha: 0.15);
        fg = AppColor.textSecondary;
        txt = 'Belum Bayar';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        txt,
        style: AppTextStyle.labelSmall.copyWith(
          color: fg,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
