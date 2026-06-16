import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/controllers/store_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class CreateStoreScreen extends GetView<StoreController> {
  const CreateStoreScreen({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 700,
      maxHeight: 700,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final sizeInBytes = await file.length();
      final sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > 2.0) {
        Get.snackbar('Error', 'Ukuran gambar toko tidak boleh melebihi 2MB');
        return;
      }
      controller.storeImage.value = file;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = Get.arguments?['isEdit'] ?? false;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Toko' : 'Buka Toko')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Upload Section
            Center(
              child: GestureDetector(
                onTap: () => _pickImage(context),
                child: Obx(() {
                  final imageFile = controller.storeImage.value;
                  final existingUrl = controller.store.value?.imageUrl;

                  return Container(
                    width: size.width * 0.9, // 90% of screen width
                    height: size.width * 0.45, // Reduced height for the image
                    decoration: BoxDecoration(
                      color: AppColor.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.border, width: 1),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (imageFile != null)
                          Image.file(imageFile, fit: BoxFit.cover)
                        else if (existingUrl != null && existingUrl.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: existingUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.store,
                              size: 80,
                              color: AppColor.textTertiary,
                            ),
                          )
                        else
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 48,
                                color: AppColor.textTertiary,
                              ),

                              SizedBox(height: 8),

                              Text(
                                'Gambar Toko',
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColor.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        if (isEdit ||
                            imageFile != null ||
                            (existingUrl != null && existingUrl.isNotEmpty))
                          Positioned.fill(
                            child: Container(
                              color: AppColor.overlay,

                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: AppColor.surfaceVariant.withValues(
                                        alpha: 0.9,
                                      ),
                                      size: 28,
                                    ),

                                    SizedBox(height: 4),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.surfaceVariant
                                            .withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      child: Text(
                                        'Ubah Foto',
                                        style: TextStyle(
                                          color: AppColor.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
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

            SizedBox(height: 24),

            // Informasi Toko Section
            Card(
              elevation: 2,
              shadowColor: AppColor.shadowDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColor.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Informasi Toko', style: AppTextStyle.headingSmall),

                    SizedBox(height: 16),

                    TextField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Toko *',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 16),

                    TextField(
                      controller: controller.descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi Toko',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            
             SizedBox(height: 16),

            
            Card(
              elevation: 2,
              shadowColor: AppColor.shadowDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColor.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Informasi Kontak', style: AppTextStyle.headingSmall),
                    
                     SizedBox(height: 16),

                    Obx(
                      () => CheckboxListTile(
                        title: const Text(
                          'Gunakan Alamat Rumah Utama',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: controller.sameAddressAsHome.value,
                        onChanged: (val) {
                          if (val != null) {
                            controller.sameAddressAsHome.value = val;
                            if (val) {
                              controller.fillAddressFromHome();
                            }
                          }
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Obx(
                      () => TextField(
                        controller: controller.addressController,
                        enabled: !controller.sameAddressAsHome.value,
                        decoration: const InputDecoration(
                          labelText: 'Alamat Toko',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ),
                    
                     SizedBox(height: 16),

                    Obx(
                      () => CheckboxListTile(
                        title: const Text(
                          'Gunakan No. HP Rumah Utama',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: controller.samePhoneAsHome.value,
                        onChanged: (val) {
                          if (val != null) {
                            controller.samePhoneAsHome.value = val;
                            if (val) {
                              controller.fillPhoneFromHome();
                            }
                          }
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),

                    Obx(
                      () => TextField(
                        controller: controller.phoneController,
                        enabled: !controller.samePhoneAsHome.value,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Telepon Toko',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
             SizedBox(height: 16),

            
            Card(
              elevation: 2,
              shadowColor: AppColor.shadowDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColor.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Pengaturan pengiriman',
                      style: AppTextStyle.headingSmall,
                    ),
                    
                     SizedBox(height: 16),

                    TextField(
                      controller: controller.defaultShippingController,
                      decoration: const InputDecoration(
                        labelText: 'Ongkos Kirim Default (Rp)',
                        border: OutlineInputBorder(),
                        helperText: 'Biaya kirim per pesanan',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),

            
             SizedBox(height: 32),
             
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoadingStore.value
                    ? null
                    : () async {
                        final success = await controller.createOrUpdateStore();
                        if (success && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: controller.isLoadingStore.value
                    ? CircularProgressIndicator(color: AppColor.textOnPrimary)
                    : Text(isEdit ? 'Simpan Perubahan' : 'Buat Toko'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
