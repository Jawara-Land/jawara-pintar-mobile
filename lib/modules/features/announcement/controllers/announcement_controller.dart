import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../models/announcement.dart';
import '../repositories/announcement_repository.dart';

class AnnouncementController extends GetxController {
  final AnnouncementRepository _repository = AnnouncementRepository();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var announcements = <AnnouncementModel>[].obs;
  var recentAnnouncements = <AnnouncementModel>[].obs;

  @override
  void onInit() {
    fetchAnnouncements();
    fetchRecentAnnouncements();
    super.onInit();
  }

  Future<void> fetchAnnouncements() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repository.getAnnouncements();
      announcements.assignAll(result);
    } catch (e) {
      errorMessage(e.toString());
      Sentry.captureException(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchRecentAnnouncements() async {
    try {
      final result = await _repository.getRecentAnnouncements();
      recentAnnouncements.assignAll(result);
    } catch (e) {
      Sentry.captureException(e);
    }
  }
}
