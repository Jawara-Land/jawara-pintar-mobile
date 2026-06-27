import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/aspiration/controllers/aspiration_controller.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/aspiration/view/ui/aspiration_form_screen.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class AspirationScreen extends GetView<AspirationController> {
  const AspirationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          title: Text(
            'Pesan Warga',
            style: AppTextStyle.headingSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            if (controller.canCreate)
              IconButton(
                onPressed: () => Get.toNamed(Routes.aspirationFormRoute),
                icon: const Icon(Icons.add),
              ),
          ],
        ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: controller.aspirations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = controller.aspirations[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: AppTextStyle.titleLarge,
                              ),
                            ),
                            if (controller.canManage)
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    await Get.to(
                                      () =>
                                          AspirationFormScreen(existing: item),
                                    );
                                    await controller.fetchAspirations();
                                  }
                                  if (value == 'delete') {
                                    final confirmed = await Get.dialog<bool>(
                                      AlertDialog(
                                        title: const Text('Hapus pesan?'),
                                        content: const Text(
                                          'Pesan yang dihapus tidak dapat dikembalikan.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: false),
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: true),
                                            child: const Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true) {
                                      await controller.deleteAspiration(
                                        item.id,
                                      );
                                    }
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Ubah'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Hapus'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(item.authorName, style: AppTextStyle.bodySmall),
                        const SizedBox(height: 8),
                        Text(item.description, style: AppTextStyle.bodySmall),
                        const SizedBox(height: 8),
                        Text(item.status, style: AppTextStyle.labelSmall),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
