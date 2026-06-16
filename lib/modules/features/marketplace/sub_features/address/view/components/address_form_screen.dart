import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/controllers/address_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class AddressFormScreen extends GetView<AddressController> {
  const AddressFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int? id = Get.arguments?['id'];
    final bool isEdit = id != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Alamat' : 'Tambah Alamat')),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller.labelController,
              decoration: InputDecoration(
                labelText: 'Label Alamat (e.g. Rumah / Kantor)',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: controller.addressController,
              decoration: InputDecoration(
                labelText: 'Alamat Lengkap *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            SizedBox(height: 16),

            TextField(
              controller: controller.phoneController,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon Penerima',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),

            SizedBox(height: 16),

            Obx(
              () => SwitchListTile(
                title: Text('Jadikan Alamat Utama'),
                value: controller.isPrimary.value,
                onChanged: (val) {
                  controller.isPrimary.value = val;
                },
              ),
            ),

            SizedBox(height: 32),

            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        final success = await controller.saveAddress(id: id);
                        if (success && context.mounted) {
                          Navigator.pop(context, true);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(color: AppColor.textOnPrimary)
                    : Text('Simpan Alamat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
