import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import '../../controllers/expense_controller.dart';
import '../../models/expense_category_model.dart';

class ExpenseCreateScreen extends GetView<ExpenseController> {
  ExpenseCreateScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  final Rx<ExpenseCategory?> _selectedCategory = Rx<ExpenseCategory?>(null);
  final Rx<File?> _proofImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      _proofImage.value = File(image.path);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColor.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory.value == null) {
      Get.snackbar(
        'Perhatian',
        'Pilih kategori pengeluaran terlebih dahulu.',
        backgroundColor: AppColor.warning,
        colorText: AppColor.textPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final success = await controller.createExpense(
      name: _nameController.text.trim(),
      categoryId: _selectedCategory.value!.id,
      amount: num.parse(_amountController.text),
      happenedAt: _dateController.text,
      proof: _proofImage.value,
    );

    if (success) {
      Get.back();
      Get.snackbar(
        'Berhasil',
        'Pengeluaran berhasil ditambahkan!',
        backgroundColor: AppColor.success,
        colorText: AppColor.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
    } else if (controller.errorMessage.isNotEmpty) {
      Get.snackbar(
        'Gagal',
        controller.errorMessage.value,
        backgroundColor: AppColor.error,
        colorText: AppColor.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: AppTextStyle.bodySmall.copyWith(color: AppColor.textTertiary),
      hintStyle: AppTextStyle.bodyMedium.copyWith(color: AppColor.textHint),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: AppColor.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.error, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        title: Text('Tambah Pengeluaran', style: AppTextStyle.headingSmall),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoadingCategories.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
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
                      Text(
                        'Informasi Pengeluaran',
                        style: AppTextStyle.titleMedium,
                      ),
                      
                      SizedBox(height: 16),

                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration(
                          label: 'Nama Pengeluaran',
                          hint: 'Contoh: Beli Sapu',
                          prefixIcon: const Icon(
                            Icons.label_outline,
                            color: AppColor.inputIcon,
                          ),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Nama pengeluaran wajib diisi'
                            : null,
                      ),
                      
                      SizedBox(height: 14),

                      Obx(
                        () => DropdownButtonFormField<ExpenseCategory>(
                          decoration: _inputDecoration(
                            label: 'Kategori',
                            prefixIcon: const Icon(
                              Icons.category_outlined,
                              color: AppColor.inputIcon,
                            ),
                          ),
                          isExpanded: true,
                          items: controller.categories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(
                                cat.name,
                                style: AppTextStyle.bodyMedium,
                              ),
                            );
                          }).toList(),
                          onChanged: (v) => _selectedCategory.value = v,
                          validator: (v) =>
                              v == null ? 'Kategori wajib dipilih' : null,
                        ),
                      ),
                      
                      SizedBox(height: 14),

                      TextFormField(
                        controller: _amountController,
                        decoration: _inputDecoration(
                          label: 'Jumlah (Rp)',
                          hint: '0',
                          prefixIcon: const Icon(
                            Icons.payments_outlined,
                            color: AppColor.inputIcon,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Jumlah wajib diisi';
                          }
                          if (num.tryParse(v) == null || num.parse(v) <= 0) {
                            return 'Masukkan jumlah yang valid';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 14),

                      TextFormField(
                        controller: _dateController,
                        decoration: _inputDecoration(
                          label: 'Tanggal Pengeluaran',
                          hint: 'Pilih tanggal',
                          prefixIcon: const Icon(
                            Icons.calendar_today_outlined,
                            color: AppColor.inputIcon,
                          ),
                          suffixIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColor.inputIcon,
                          ),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Tanggal wajib dipilih'
                            : null,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bukti Pengeluaran',
                            style: AppTextStyle.titleMedium,
                          ),

                          Text(
                            'Opsional',
                            style: AppTextStyle.caption.copyWith(
                              color: AppColor.primary,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 12),

                      Obx(
                        () => GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.inputFill,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _proofImage.value != null
                                    ? AppColor.primary
                                    : AppColor.inputBorder,
                                style: _proofImage.value == null
                                    ? BorderStyle.solid
                                    : BorderStyle.solid,
                              ),
                            ),
                            child: _proofImage.value != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Image.file(
                                      _proofImage.value!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryLight,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.upload_file_outlined,
                                          color: AppColor.primary,
                                          size: 24,
                                        ),
                                      ),
                                      
                                      SizedBox(height: 8),

                                      Text(
                                        'Ketuk untuk memilih gambar',
                                        style: AppTextStyle.bodySmall.copyWith(
                                          color: AppColor.textTertiary,
                                        ),
                                      ),
                                      
                                      SizedBox(height: 2),

                                      Text(
                                        'JPEG / PNG, maks. 5MB',
                                        style: AppTextStyle.caption,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),

                      Obx(
                        () => _proofImage.value != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: TextButton.icon(
                                  onPressed: () => _proofImage.value = null,
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColor.error,
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Hapus gambar',
                                    style: AppTextStyle.labelSmall.copyWith(
                                      color: AppColor.error,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isSubmitting.value ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      disabledBackgroundColor: AppColor.primary.withValues(
                        alpha: 0.6,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColor.onPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Simpan Pengeluaran',
                            style: AppTextStyle.labelLarge.copyWith(
                              color: AppColor.onPrimary,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }
}
