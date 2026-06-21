import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/currency_text.dart';
import '../../controllers/expense_controller.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final int id;
  const ExpenseDetailScreen({super.key, required this.id});

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  final ExpenseController controller = Get.find<ExpenseController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchExpenseDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        title: Text('Detail Pengeluaran', style: AppTextStyle.headingSmall),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.selectedExpense.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColor.error,
                ),

                SizedBox(height: 12),

                Text(
                  controller.errorMessage.value,
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () => controller.fetchExpenseDetails(widget.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                  ),
                  child: Text(
                    'Coba Lagi',
                    style: AppTextStyle.labelLarge.copyWith(
                      color: AppColor.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final expense = controller.selectedExpense.value;
        if (expense == null) {
          return Center(
            child: Text(
              'Data pengeluaran tidak ditemukan.',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.textTertiary,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.errorLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColor.error.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColor.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        color: AppColor.error,
                        size: 28,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      'Total Pengeluaran',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.errorDark,
                      ),
                    ),

                    SizedBox(height: 4),

                    CurrencyText(
                      expense.amount.toInt(),
                      style: AppTextStyle.headingLarge.copyWith(
                        color: AppColor.error,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              Container(
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
                  children: [
                    _DetailRow(
                      icon: Icons.label_outline,
                      label: 'Nama Pengeluaran',
                      value: expense.name,
                    ),

                    _divider(),

                    _DetailRow(
                      icon: Icons.category_outlined,
                      label: 'Kategori',
                      value: expense.expenseCategory ?? '-',
                    ),

                    _divider(),

                    _DetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal',
                      value: expense.happenedAt ?? '-',
                    ),

                    _divider(),

                    _DetailRow(
                      icon: Icons.verified_outlined,
                      label: 'Diverifikasi Oleh',
                      value: expense.verificator ?? 'Belum diverifikasi',
                      valueColor: expense.verificator != null
                          ? AppColor.success
                          : AppColor.warning,
                    ),

                    if (expense.verifiedAt != null) ...[
                      _divider(),

                      _DetailRow(
                        icon: Icons.access_time,
                        label: 'Waktu Verifikasi',
                        value: expense.verifiedAt!,
                      ),
                    ],
                  ],
                ),
              ),

              if (expense.proof != null) ...[
                SizedBox(height: 16),

                Container(
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.image_outlined,
                            size: 18,
                            color: AppColor.textTertiary,
                          ),
                          
                          SizedBox(width: 8),

                          Text(
                            'Bukti Pengeluaran',
                            style: AppTextStyle.titleMedium,
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 12),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          expense.proof!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              height: 180,
                              color: AppColor.surfaceVariant,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.primary,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColor.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.broken_image_outlined,
                                      color: AppColor.textTertiary,
                                      size: 32,
                                    ),
                                    
                                    SizedBox(height: 4),

                                    Text(
                                      'Gambar tidak dapat dimuat',
                                      style: AppTextStyle.caption,
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _divider() => const Divider(
    height: 1,
    color: AppColor.border,
    indent: 16,
    endIndent: 16,
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColor.textTertiary),
          
          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyle.caption),
                
                SizedBox(height: 2),
                
                Text(
                  value,
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: valueColor ?? AppColor.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
