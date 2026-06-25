import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';

class EventController extends GetxController {
  final EventRepository _repository = EventRepository();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var events = <EventModel>[].obs;
  var recentEvents = <EventModel>[].obs;

  @override
  void onInit() {
    fetchEvents();
    fetchRecentEvents();
    super.onInit();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repository.getEvents();
      events.assignAll(result);
    } catch (e) {
      errorMessage(e.toString());
      Sentry.captureException(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchRecentEvents() async {
    try {
      final result = await _repository.getRecentEvents();
      recentEvents.assignAll(result);
    } catch (e) {
      Sentry.captureException(e);
    }
  }
}
