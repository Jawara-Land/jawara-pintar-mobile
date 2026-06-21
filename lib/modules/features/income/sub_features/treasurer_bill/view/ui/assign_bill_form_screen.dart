import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/treasurer_bill/controllers/assign_bill_form_controller.dart';
import 'package:jawara_mobile/modules/features/income/models/contribution_category_model.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class AssignBillFormScreen extends GetView<AssignBillFormController> {
  const AssignBillFormScreen({super.key});

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
        title: Text('Buat Penagihan Baru', style: AppTextStyle.headingMedium),
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
                    Text('Pilih Iuran', style: AppTextStyle.labelLarge),

                    SizedBox(height: 8),

                    Obx(() {
                      return DropdownButtonFormField<ContributionCategoryModel>(
                        dropdownColor: AppColor.surface,
                        borderRadius: BorderRadius.circular(16),
                        decoration: InputDecoration(
                          hintText: 'Pilih tipe iuran',
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
                        items: controller
                            .incomeController
                            .contributionCategories
                            .map((cat) {
                              return DropdownMenuItem<
                                ContributionCategoryModel
                              >(
                                value: cat,
                                child: Text(
                                  '${cat.name} (${cat.amount != null ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(cat.amount) : "Template"})',
                                ),
                              );
                            })
                            .toList(),
                        onChanged: controller.onCategoryChanged,
                        validator: (value) =>
                            value == null ? 'Iuran wajib dipilih' : null,
                      );
                    }),
                    
                    SizedBox(height: 20),

                    Text('Bulan Penagihan', style: AppTextStyle.labelLarge),
                    
                    SizedBox(height: 8),

                    InkWell(
                      onTap: () => controller.selectMonth(context),
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
                                  'MMMM yyyy',
                                ).format(controller.selectedMonth.value),
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
                    
                    SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Target Keluarga', style: AppTextStyle.titleLarge),

                        Obx(() {
                          final allSelected =
                              controller
                                  .incomeController
                                  .selectedFamilyIds
                                  .length ==
                              controller.incomeController.familiesList.length;
                          return TextButton.icon(
                            onPressed: () {
                              if (allSelected) {
                                controller.incomeController.selectedFamilyIds
                                    .clear();
                              } else {
                                controller.incomeController.selectedFamilyIds
                                    .assignAll(
                                      controller.incomeController.familiesList
                                          .map((f) => f.id),
                                    );
                              }
                            },
                            icon: Icon(
                              allSelected ? Icons.deselect : Icons.select_all,
                              size: 18,
                            ),
                            label: Text(
                              allSelected ? 'Batal Semua' : 'Pilih Semua',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    
                    SizedBox(height: 8),

                    Obx(() {
                      if (controller.incomeController.familiesList.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Text('Tidak ada target keluarga terdaftar.'),
                          ),
                        );
                      }
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColor.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.border),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              controller.incomeController.familiesList.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1, color: AppColor.border),
                          itemBuilder: (context, index) {
                            final family =
                                controller.incomeController.familiesList[index];
                            return Obx(() {
                              final isChecked = controller
                                  .incomeController
                                  .selectedFamilyIds
                                  .contains(family.id);
                              return CheckboxListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                title: Text(
                                  family.name,
                                  style: AppTextStyle.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Kepala Keluarga: ${family.headOfFamilyName ?? "-"}',
                                  style: AppTextStyle.bodySmall.copyWith(
                                    color: AppColor.textTertiary,
                                  ),
                                ),
                                activeColor: AppColor.primary,
                                value: isChecked,
                                onChanged: (val) {
                                  if (val == true) {
                                    controller
                                        .incomeController
                                        .selectedFamilyIds
                                        .add(family.id);
                                  } else {
                                    controller
                                        .incomeController
                                        .selectedFamilyIds
                                        .remove(family.id);
                                  }
                                },
                              );
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          
          Obx(() {
            final isBtnDisabled =
                controller.incomeController.isAssigning.value ||
                controller.incomeController.selectedFamilyIds.isEmpty ||
                controller.selectedCategory.value == null;

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
                  onPressed: isBtnDisabled
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            controller.incomeController.processAssignBills();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.incomeController.isAssigning.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Keluarkan Tagihan (${controller.incomeController.selectedFamilyIds.length})',
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
