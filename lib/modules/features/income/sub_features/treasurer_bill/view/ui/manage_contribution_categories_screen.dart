import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/currency_text.dart';

class ManageContributionCategoriesScreen extends GetView<IncomeController> {
  const ManageContributionCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primary,
      ),
      body: Obx(() {
        if (controller.isLoadingContributorCategories.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        if (controller.contributionCategories.isEmpty) {
          return const Center(child: Text('Belum ada kategori iuran.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.contributionCategories.length,
          itemBuilder: (context, index) {
            final item = controller.contributionCategories[index];
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
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColor.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.payments_outlined,
                      color: AppColor.primary,
                      size: 24,
                    ),
                  ),
                  
                  SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: AppTextStyle.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        SizedBox(height: 4),

                        Text(
                          item.category ?? 'Kategori iuran',
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: 8),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CurrencyText(
                        item.amount ?? 0,
                        style: AppTextStyle.titleLarge.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: (item.isRecurring == true
                              ? AppColor.primaryLight
                              : AppColor.backgroundAlt),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.isRecurring == true ? 'Recurring' : 'Sekali',
                          style: AppTextStyle.caption.copyWith(
                            color: (item.isRecurring == true
                                ? AppColor.primary
                                : AppColor.info),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final categoryIdController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tambah Kategori Iuran'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Kategori',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textSecondary,
                  ),
                ),
                
                SizedBox(height: 6),

                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Cth: Iuran Kebersihan Bulanan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    fillColor: AppColor.inputFill,
                    filled: true,
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Nama wajib diisi'
                      : null,
                ),
                
                SizedBox(height: 14),

                Text(
                  'Nominal Iuran (Rp)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textSecondary,
                  ),
                ),
                
                SizedBox(height: 6),

                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Cth: 50000',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    fillColor: AppColor.inputFill,
                    filled: true,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Nominal wajib diisi';
                    }
                    if (int.tryParse(val) == null || int.parse(val) <= 0) {
                      return 'Nominal tidak valid';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 14),

                Text(
                  'ID Kategori Kontribusi',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textSecondary,
                  ),
                ),
                
                SizedBox(height: 6),

                TextFormField(
                  controller: categoryIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Cth: 1',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    fillColor: AppColor.inputFill,
                    filled: true,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'ID Kategori wajib diisi';
                    }
                    if (int.tryParse(val) == null || int.parse(val) <= 0) {
                      return 'ID Kategori tidak valid';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColor.textSecondary),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final name = nameController.text.trim();
                final amount = int.parse(amountController.text.trim());
                final categoryId = int.parse(categoryIdController.text.trim());

                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );

                final result = await controller.storeContributionCategory(
                  name: name,
                  amount: amount,
                  contributionCategoryId: categoryId,
                );

                Get.back();
                
                if (Get.isDialogOpen ?? false) Get.back();

                if (result['success'] == true) {
                  controller.fetchContributionCategories();
                  Get.snackbar(
                    'Sukses',
                    result['message'] ?? 'Kategori berhasil ditambahkan',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'Gagal',
                    result['message'] ?? 'Gagal menambahkan kategori',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
