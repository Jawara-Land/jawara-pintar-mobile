import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/non_contribution/controllers/add_income_non_contribution_controller.dart';
import 'package:jawara_mobile/modules/features/income/models/income_category_model.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class AddIncomeNonContributionScreen extends GetView<AddIncomeNonContributionController> {
  const AddIncomeNonContributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Tambah Pemasukan Lain', style: AppTextStyle.headingMedium),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kategori Pemasukan', style: AppTextStyle.labelLarge),

                    SizedBox(height: 8),

                    Obx(() {
                      return DropdownButtonFormField<IncomeCategoryModel>(
                        dropdownColor: AppColor.surface,
                        borderRadius: BorderRadius.circular(16),
                        decoration: InputDecoration(
                          hintText: 'Pilih kategori',
                          fillColor: AppColor.inputFill,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColor.border,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColor.inputBorder,
                            ),
                          ),
                        ),
                        initialValue: controller.selectedCategory.value,
                        items: controller.incomeController.incomeCategories.map(
                          (cat) {
                            return DropdownMenuItem<IncomeCategoryModel>(
                              value: cat,
                              child: Text(cat.name),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          controller.selectedCategory.value = val;
                        },
                        validator: (value) =>
                            value == null ? 'Kategori wajib dipilih' : null,
                      );
                    }),

                    SizedBox(height: 20),

                    Text(
                      'Keterangan / Nama Pemasukan',
                      style: AppTextStyle.labelLarge,
                    ),
                    
                    SizedBox(height: 8),

                    TextFormField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Donasi Hamba Allah untuk Paving',
                        fillColor: AppColor.inputFill,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColor.border),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColor.inputBorder,
                          ),
                        ),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Keterangan wajib diisi'
                          : null,
                    ),
                    
                    SizedBox(height: 20),

                    Text('Nominal (Rp)', style: AppTextStyle.labelLarge),
                    
                    SizedBox(height: 8),

                    TextFormField(
                      controller: controller.amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nominal tanpa titik/koma',
                        fillColor: AppColor.inputFill,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColor.border),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColor.inputBorder,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nominal wajib diisi';
                        }
                        final numVal = int.tryParse(value);
                        if (numVal == null || numVal <= 0) {
                          return 'Nominal tidak valid';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 20),

                    Text('Tanggal Terjadi', style: AppTextStyle.labelLarge),
                    
                    SizedBox(height: 8),

                    InkWell(
                      onTap: () => controller.selectDate(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.inputFill,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              return Text(
                                DateFormat(
                                  'dd MMMM yyyy',
                                ).format(controller.selectedDate.value),
                                style: AppTextStyle.bodyLarge,
                              );
                            }),
                            
                            Icon(
                              Icons.calendar_today,
                              color: AppColor.textTertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),

                    Text(
                      'Bukti Pembayaran (Opsional)',
                      style: AppTextStyle.labelLarge,
                    ),
                    
                    SizedBox(height: 8),

                    InkWell(
                      onTap: () => controller.pickImage(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.inputFill,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColor.border,
                            style: controller.proofFile.value == null
                                ? BorderStyle.solid
                                : BorderStyle.none,
                          ),
                        ),
                        child: Obx(() {
                          final file = controller.proofFile.value;
                          if (file == null) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 28,
                                    color: AppColor.primary,
                                  ),
                                ),
                                
                                SizedBox(height: 10),

                                Text(
                                  'Pilih Gambar Bukti',
                                  style: AppTextStyle.bodySmall.copyWith(
                                    color: AppColor.textTertiary,
                                  ),
                                ),
                              ],
                            );
                          }
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.file(file, fit: BoxFit.cover),
                                ),

                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.proofFile.value = null;
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Obx(() {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColor.surface,
                border: Border(top: BorderSide(color: AppColor.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      controller.incomeController.isStoringNonContribution.value
                      ? null
                      : () => controller.submitForm(formKey),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      controller.incomeController.isStoringNonContribution.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Simpan Pemasukan',
                          style: AppTextStyle.labelLarge.copyWith(
                            color: AppColor.onPrimary,
                          ),
                        ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
