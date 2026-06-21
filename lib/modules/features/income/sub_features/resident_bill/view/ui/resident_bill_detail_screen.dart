import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/resident_bill/controllers/resident_bill_detail_controller.dart';
import 'package:jawara_mobile/shared/widgets/currency_text.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class ResidentBillDetailScreen extends GetView<ResidentBillDetailController> {
  const ResidentBillDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Detail Tagihan Iuran', style: AppTextStyle.headingMedium),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        final item = controller.bill.value;
        if (item == null) {
          return const Center(child: Text('Tagihan tidak ditemukan.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.shadow.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
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
                            item.billMonth,
                            style: AppTextStyle.headingSmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildStatusBadge(item.status),
                      ],
                    ),

                    Divider(height: 32, color: AppColor.border),

                    _buildRowDetail('Nama Iuran', item.contributionName),

                    SizedBox(height: 16),

                    _buildRowDetail('Keluarga', item.familyName),

                    SizedBox(height: 16),

                    _buildRowDetail(
                      'Nominal',
                      formatRupiah(int.tryParse(item.amount) ?? 0),
                      valColor: AppColor.primary,
                      isBoldVal: true,
                    ),

                    if (item.verifiedAt != null) ...[
                      SizedBox(height: 16),

                      _buildRowDetail('Waktu Verifikasi', item.verifiedAt!),
                    ],

                    if (item.rejectedReason != null) ...[
                      Divider(height: 32, color: AppColor.border),

                      Text(
                        'Alasan Penolakan:',
                        style: AppTextStyle.labelMedium.copyWith(
                          color: AppColor.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.error.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColor.error.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          item.rejectedReason!,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.errorDark,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 28),

              if (item.isUnpaid) ...[
                Text(
                  'Panduan Pembayaran Transfer',
                  style: AppTextStyle.titleLarge,
                ),

                SizedBox(height: 12),

                Obx(() {
                  if (controller.isLoadingChannels.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.channels.isEmpty) {
                    return const Text(
                      'Saluran transfer bank manual belum dikonfigurasi.',
                    );
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.shadow.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(color: AppColor.border),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.channels.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: AppColor.border),
                      itemBuilder: (context, index) {
                        final ch = controller.channels[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          title: Text(
                            ch.name,
                            style: AppTextStyle.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6),

                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColor.background,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColor.border),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: SelectableText(
                                        '${ch.accountNumber}\nA/N ${ch.accountName}',
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ),

                                    IconButton(
                                      icon: const Icon(
                                        Icons.copy_all_outlined,
                                        size: 22,
                                        color: AppColor.primary,
                                      ),
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(text: ch.accountNumber),
                                        );
                                        Get.rawSnackbar(
                                          messageText: const Text(
                                            'Nomor rekening disalin ke clipboard',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.black87,
                                          margin: const EdgeInsets.all(16),
                                          borderRadius: 12,
                                        );
                                      },
                                      tooltip: 'Salin nomor rekening',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),

                              Text(
                                'Silakan transfer nominal pas, kemudian upload bukti.',
                                style: AppTextStyle.caption.copyWith(
                                  color: AppColor.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),

                SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => controller.pickAndUploadProof(context),
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text('Kirim/Unggah Bukti Transfer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],

              if (item.paymentProof != null) ...[
                Text('Bukti Pembayaran Anda', style: AppTextStyle.titleLarge),
                
                SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(
                    color: AppColor.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.shadow.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: AppColor.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: InteractiveViewer(
                      child: Image.network(
                        item.paymentProof!.startsWith('http')
                            ? item.paymentProof!
                            : 'http://10.0.2.2:8000/storage/${item.paymentProof}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: AppColor.textHint,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRowDetail(
    String label,
    String val, {
    Color? valColor,
    bool isBoldVal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.labelMedium.copyWith(
            color: AppColor.textTertiary,
          ),
        ),
        Text(
          val,
          style: AppTextStyle.titleMedium.copyWith(
            color: valColor ?? AppColor.textPrimary,
            fontWeight: isBoldVal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
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
