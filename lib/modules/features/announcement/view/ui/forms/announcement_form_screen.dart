import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/modules/features/announcement/controllers/announcement_form_controller.dart';

class AnnouncementFormScreen extends GetView<AnnouncementFormController> {
  const AnnouncementFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text('Tambah Pengumuman', style: AppTextStyle.headingSmall),
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
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => controller.titleController.value = val,
            ),
            
            SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Konten',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              onChanged: (val) => controller.contentController.value = val,
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
