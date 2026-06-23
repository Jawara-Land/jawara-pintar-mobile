import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import '../../controllers/transfer_channel_form_controller.dart';
import '../components/image_picker_tile.dart';

class TransferChannelFormScreen extends GetView<TransferChannelFormController> {
  const TransferChannelFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        title: Text(
          controller.isEditing ? 'Edit Channel' : 'Tambah Channel',
          style: AppTextStyle.headingSmall,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ChannelTextFormField(
                fieldController: controller.nameController,
                label: 'Nama Channel',
                hint: 'Contoh: Bank Mandiri',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              Obx(
                () => DropdownButtonFormField<String>(
                  key: ValueKey(controller.selectedType.value),
                  initialValue: controller.selectedType.value,
                  decoration: channelInputDecoration('Tipe Channel'),
                  items: TransferChannelFormController.channelTypes
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(
                            t.toUpperCase(),
                            style: AppTextStyle.bodyMedium,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) controller.selectedType.value = val;
                  },
                ),
              ),
              const SizedBox(height: 16),
              ChannelTextFormField(
                fieldController: controller.accountController,
                label: 'Nomor Rekening (opsional)',
                hint: 'Contoh: 1234567890',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ChannelTextFormField(
                fieldController: controller.holderController,
                label: 'Nama Pemilik (opsional)',
                hint: 'Contoh: Kas RT 01',
              ),
              const SizedBox(height: 16),
              ChannelTextFormField(
                fieldController: controller.noteController,
                label: 'Catatan (opsional)',
                hint: 'Contoh: Transfer sesuai nominal tagihan',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ImagePickerTile(
                label: 'Logo / Thumbnail',
                hint: controller.isEditing &&
                        controller.editChannel?.thumbnail != null
                    ? 'Sudah ada gambar (opsional ganti)'
                    : 'Pilih logo channel (opsional)',
                file: controller.thumbnailFile,
                onTap: () => controller.pickImage(isThumbnail: true),
              ),
              const SizedBox(height: 12),
              ImagePickerTile(
                label: 'QR Code (opsional)',
                hint: controller.isEditing &&
                        controller.editChannel?.qrImage != null
                    ? 'Sudah ada QR (opsional ganti)'
                    : 'Pilih gambar QR code',
                file: controller.qrImageFile,
                onTap: () => controller.pickImage(isThumbnail: false),
              ),
              const SizedBox(height: 28),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isSubmitting.value ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: AppColor.primaryLight,
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
                          controller.isEditing
                              ? 'Simpan Perubahan'
                              : 'Buat Channel',
                          style: AppTextStyle.labelLarge.copyWith(
                            color: AppColor.onPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final ok = await controller.submit();
    if (ok) {
      Get.back();
      Get.snackbar(
        'Berhasil',
        controller.isEditing
            ? 'Transfer channel berhasil diperbarui!'
            : 'Transfer channel berhasil dibuat! 🎉',
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
}

InputDecoration channelInputDecoration(String label, {String? hint}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: AppTextStyle.bodySmall.copyWith(color: AppColor.textTertiary),
    hintStyle: AppTextStyle.bodyMedium.copyWith(color: AppColor.textHint),
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

class ChannelTextFormField extends StatelessWidget {
  const ChannelTextFormField({
    super.key,
    required this.fieldController,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController fieldController;
  final String label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: fieldController,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: channelInputDecoration(label, hint: hint),
      validator: validator,
    );
  }
}
