import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../models/activity_log_model.dart';
import '../repositories/log_history_repository.dart';

class LogHistoryController extends GetxController {
  final LogHistoryRepository _repository = LogHistoryRepository();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var logs = <ActivityLog>[].obs;

  var searchDescription = ''.obs;
  var searchCauser = ''.obs;
  var filterFrom = ''.obs;
  var filterTo = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repository.getActivityLogs(
        description: searchDescription.value.isEmpty
            ? null
            : searchDescription.value,
        causer: searchCauser.value.isEmpty ? null : searchCauser.value,
        from: filterFrom.value.isEmpty ? null : filterFrom.value,
        to: filterTo.value.isEmpty ? null : filterTo.value,
      );
      logs.assignAll(result);
    } catch (e, stackTrace) {
      errorMessage(e.toString());
      await Sentry.captureException(e, stackTrace: stackTrace);
    } finally {
      isLoading(false);
    }
  }

  void applyDescriptionFilter(String value) {
    searchDescription(value);
    fetchLogs();
  }

  void applyCauserFilter(String value) {
    searchCauser(value);
    fetchLogs();
  }

  void applyDateRange({String? from, String? to}) {
    if (from != null) filterFrom(from);
    if (to != null) filterTo(to);
    fetchLogs();
  }

  void clearFilters() {
    searchDescription('');
    searchCauser('');
    filterFrom('');
    filterTo('');
    fetchLogs();
  }
}
