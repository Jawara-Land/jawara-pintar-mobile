import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/modules/features/event/controllers/event_form_controller.dart';

class EventFormScreen extends GetView<EventFormController> {
  const EventFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text('Tambah Kegiatan', style: AppTextStyle.headingSmall),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nama Kegiatan',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => controller.nameController.value = val,
            ),
            
            SizedBox(height: 16),

            Text('Kategori', style: AppTextStyle.bodySmall),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: controller.selectedCategoryId.value,
              items: controller.categories.map((c) {
                return DropdownMenuItem(value: c.id, child: Text(c.name));
              }).toList(),
              onChanged: (val) => controller.selectedCategoryId.value = val,
            ),
            
            SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Tanggal (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => controller.dateController.value = val,
            ),
            
            SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => controller.locationController.value = val,
            ),
            
            SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Penanggung Jawab',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => controller.picController.value = val,
            ),
            
            SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (val) => controller.descriptionController.value = val,
            ),
            
            SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                ),
                onPressed: controller.submit,
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
