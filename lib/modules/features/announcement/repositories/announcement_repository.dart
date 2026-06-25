import 'package:jawara_mobile/shared/utils/services/api_service.dart';
import '../constants/announcement_api_constant.dart';
import '../models/announcement.dart';
import 'package:jawara_mobile/shared/models/base_response.dart';

class AnnouncementRepository {
  Future<List<AnnouncementModel>> getAnnouncements() async {
    final response = await ApiService.get(
      AnnouncementApiConstant.listBroadcasts,
    );
    final baseResponse = BaseResponse<List<AnnouncementModel>>.fromJson(
      response,
      fromJsonT: (data) => (data['data'] as List)
          .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    if (baseResponse.success) {
      return baseResponse.data ?? [];
    }
    throw Exception(baseResponse.message);
  }

  Future<List<AnnouncementModel>> getRecentAnnouncements() async {
    final response = await ApiService.get(
      AnnouncementApiConstant.recentBroadcasts,
    );
    final baseResponse = BaseResponse<List<AnnouncementModel>>.fromJson(
      response,
      fromJsonT: (data) => (data['data'] as List)
          .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    if (baseResponse.success) {
      return baseResponse.data ?? [];
    }
    throw Exception(baseResponse.message);
  }

  Future<Map<String, dynamic>> createAnnouncement(
    Map<String, String> data,
  ) async {
    return await ApiService.postMultipart(
      AnnouncementApiConstant.listBroadcasts,
      fields: data,
      files: {},
    );
  }

  Future<Map<String, dynamic>> updateAnnouncement(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await ApiService.put(
      '${AnnouncementApiConstant.listBroadcasts}/$id',
      data,
    );
  }

  Future<Map<String, dynamic>> deleteAnnouncement(int id) async {
    return await ApiService.delete(
      '${AnnouncementApiConstant.listBroadcasts}/$id',
    );
  }
}
