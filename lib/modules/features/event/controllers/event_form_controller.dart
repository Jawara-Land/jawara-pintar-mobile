import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:jawara_mobile/modules/features/event/controllers/event_controller.dart';
import 'package:jawara_mobile/modules/features/event/models/event_category.dart';
import 'package:jawara_mobile/modules/features/event/repositories/event_repository.dart';

class EventFormController extends GetxController {
  final EventRepository repository = EventRepository();
  final categories = <EventCategoryModel>[].obs;

  final nameController = ''.obs;
  final dateController = ''.obs;
  final locationController = ''.obs;
  final picController = ''.obs;
  final descriptionController = ''.obs;
  final selectedCategoryId = Rxn<int>();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final res = await repository.getCategories();
      categories.assignAll(res);
    } catch (e) {
      Sentry.captureException(e);
      Get.snackbar('Error', 'Gagal memuat kategori: $e');
    }
  }

  Future<void> submit() async {
    if (nameController.value.isEmpty ||
        selectedCategoryId.value == null ||
        dateController.value.isEmpty ||
        locationController.value.isEmpty ||
        picController.value.isEmpty ||
        descriptionController.value.isEmpty) {
      Get.snackbar('Validasi', 'Mohon lengkapi semua field yang wajib');
      return;
    }

    isLoading(true);
    try {
      await repository.createEvent({
        'name': nameController.value,
        'event_category_id': selectedCategoryId.value.toString(),
        'date': dateController.value,
        'location': locationController.value,
        'person_in_charge': picController.value,
        'description': descriptionController.value,
      });
      Get.back();
      Get.snackbar('Sukses', 'Kegiatan berhasil ditambahkan');
      if (Get.isRegistered<EventController>()) {
        Get.find<EventController>().fetchEvents();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan kegiatan: $e');
      Sentry.captureException(e);
    } finally {
      isLoading(false);
    }
  }
}
