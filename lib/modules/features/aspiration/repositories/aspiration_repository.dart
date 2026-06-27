import 'package:jawara_mobile/modules/features/aspiration/constants/aspiration_api_constant.dart';
import 'package:jawara_mobile/modules/features/aspiration/models/aspiration_model.dart';
import 'package:jawara_mobile/shared/models/base_response.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

class AspirationRepository {
  Future<List<AspirationModel>> getAspirations() async {
    final response = await ApiService.get(AspirationApiConstant.aspirations);
    final baseResponse = BaseResponse<List<AspirationModel>>.fromJson(
      response,
      fromJsonT: (data) => (data['data'] as List<dynamic>? ?? const [])
          .map((e) => AspirationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    if (baseResponse.success) return baseResponse.data ?? [];
    throw Exception(baseResponse.message);
  }

  Future<List<AspirationModel>> getMyAspirations() async {
    final response = await ApiService.get(
      '${AspirationApiConstant.aspirations}/history',
    );
    final baseResponse = BaseResponse<List<AspirationModel>>.fromJson(
      response,
      fromJsonT: (data) => (data['data'] as List<dynamic>? ?? const [])
          .map((e) => AspirationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    if (baseResponse.success) return baseResponse.data ?? [];
    throw Exception(baseResponse.message);
  }

  Future<AspirationModel> createAspiration({
    required String title,
    required String description,
  }) async {
    final response = await ApiService.post(
      AspirationApiConstant.createAspiration,
      {'title': title, 'description': description},
    );

    if ((response['_statusCode'] == 200 || response['_statusCode'] == 201) &&
        response['success'] == true) {
      return AspirationModel.fromJson(response['data'] as Map<String, dynamic>);
    }
    throw Exception(response['message'] ?? 'Failed to create aspiration');
  }

  Future<AspirationModel> updateAspiration({
    required int id,
    required String title,
    required String description,
  }) async {
    final response = await ApiService.put(
      '${AspirationApiConstant.aspirations}/$id',
      {'title': title, 'description': description},
    );

    if (response['_statusCode'] == 200 && response['success'] == true) {
      return AspirationModel.fromJson(response['data'] as Map<String, dynamic>);
    }
    throw Exception(response['message'] ?? 'Failed to update aspiration');
  }

  Future<void> deleteAspiration(int id) async {
    final response = await ApiService.delete(
      '${AspirationApiConstant.aspirations}/$id',
    );
    if (response['_statusCode'] == 200 && response['success'] == true) return;
    throw Exception(response['message'] ?? 'Failed to delete aspiration');
  }

  Future<List<AspirationCategory>> getCategories() async {
    final response = await ApiService.get(
      AspirationApiConstant.aspirationCategories,
    );
    final baseResponse = BaseResponse<List<AspirationCategory>>.fromJson(
      response,
      fromJsonT: (data) => (data['data'] as List<dynamic>? ?? const [])
          .map((e) => AspirationCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    if (baseResponse.success) return baseResponse.data ?? [];
    throw Exception(baseResponse.message);
  }
}
