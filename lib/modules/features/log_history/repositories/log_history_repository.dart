import 'package:jawara_mobile/shared/utils/services/api_service.dart';
import '../constants/log_history_api_constant.dart';
import '../models/activity_log_model.dart';

class LogHistoryRepository {
  Future<List<ActivityLog>> getActivityLogs({
    int page = 1,
    String? description,
    String? causer,
    String? from,
    String? to,
  }) async {
    final queryParams = <String>['page=$page'];
    if (description != null && description.isNotEmpty) {
      queryParams.add('filter[description]=$description');
    }
    if (causer != null && causer.isNotEmpty) {
      queryParams.add('filter[causer]=$causer');
    }
    if (from != null && from.isNotEmpty) {
      queryParams.add('filter[from]=$from');
    }
    if (to != null && to.isNotEmpty) {
      queryParams.add('filter[to]=$to');
    }

    final queryString = '?${queryParams.join('&')}';
    final url = '${LogHistoryApiConstant.activityLogs}$queryString';

    final response = await ApiService.get(url);

    if (response['_statusCode'] == 200 && response['success'] == true) {
      final List dataList = response['data']['data'] ?? [];
      return dataList.map((e) => ActivityLog.fromJson(e)).toList();
    }
    throw Exception(response['message'] ?? 'Gagal memuat riwayat aktivitas');
  }
}
