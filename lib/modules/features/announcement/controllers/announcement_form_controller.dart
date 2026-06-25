import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/announcement/controllers/announcement_controller.dart';
import 'package:jawara_mobile/modules/features/announcement/repositories/announcement_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AnnouncementFormController extends GetxController {
  final AnnouncementRepository repository = AnnouncementRepository();

  final titleController = ''.obs;
  final contentController = ''.obs;

  final isLoading = false.obs;

  Future<void> submit() async {
    if (titleController.value.isEmpty || contentController.value.isEmpty) {
      Get.snackbar('Validasi', 'Judul dan konten wajib diisi');
      return;
    }

    isLoading(true);
    try {
      Map<String, String> data = {
        'title': titleController.value,
        'content': contentController.value,
      };

      await repository.createAnnouncement(data);
      Get.back();
      Get.snackbar('Sukses', 'Pengumuman berhasil ditambahkan');
      if (Get.isRegistered<AnnouncementController>()) {
        Get.find<AnnouncementController>().fetchAnnouncements();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan pengumuman: $e');
      Sentry.captureException(e);
    } finally {
      isLoading(false);
    }
  }
}
