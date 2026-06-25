import 'package:jawara_mobile/shared/utils/services/api_service.dart';
import '../constants/event_api_constant.dart';
import '../models/event.dart';
import '../models/event_category.dart';
import 'package:jawara_mobile/shared/models/base_response.dart';

class EventRepository {
  Future<List<EventModel>> getEvents() async {
    final response = await ApiService.get(EventApiConstant.listEvents);
    final baseResponse = BaseResponse<List<EventModel>>.fromJson(
      response,
      fromJsonT: (data) => (data['data'] as List)
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    if (baseResponse.success) {
      return baseResponse.data ?? [];
    }
    throw Exception(baseResponse.message);
  }

  Future<List<EventModel>> getRecentEvents() async {
    final response = await ApiService.get(EventApiConstant.recentEvents);
    final baseResponse = BaseResponse<List<EventModel>>.fromJson(
      response,
      fromJsonT: (data) => (data['data'] as List)
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    if (baseResponse.success) {
      return baseResponse.data ?? [];
    }
    throw Exception(baseResponse.message);
  }

  Future<List<EventCategoryModel>> getCategories() async {
    final response = await ApiService.get(EventApiConstant.eventCategories);
    final baseResponse = BaseResponse<List<EventCategoryModel>>.fromJson(
      response,
      fromJsonT: (data) => (data['data'] as List)
          .map((e) => EventCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (baseResponse.success) {
      return baseResponse.data ?? [];
    }
    throw Exception(baseResponse.message);
  }

  Future<Map<String, dynamic>> createEvent(Map<String, String> data) async {
    return await ApiService.postMultipart(
      EventApiConstant.listEvents,
      fields: data,
      files: {},
    );
  }

  Future<Map<String, dynamic>> updateEvent(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await ApiService.put('${EventApiConstant.listEvents}/$id', data);
  }

  Future<Map<String, dynamic>> deleteEvent(int id) async {
    return await ApiService.delete('${EventApiConstant.listEvents}/$id');
  }
}
