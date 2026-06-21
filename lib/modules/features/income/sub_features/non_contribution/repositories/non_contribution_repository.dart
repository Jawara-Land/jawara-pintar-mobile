import 'dart:io';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';
import '../../../constants/income_api_constant.dart';
import '../../../models/income_category_model.dart';
import '../../../models/income_non_contribution_model.dart';
import '../../../models/income_non_contribution_detail_model.dart';

class NonContributionRepository {
  NonContributionRepository._();

  static List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is List) {
        return nested
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      if (data['items'] is List) {
        return (data['items'] as List)
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }
    return [];
  }

  static Future<List<IncomeCategoryModel>>
  getNonContributionCategories() async {
    final response = await ApiService.get(IncomeApiConstant.categoriesOptions);
    if (response['success'] == true && response['data'] != null) {
      final list = _extractList(response['data']);
      return list.map((e) => IncomeCategoryModel.fromJson(e)).toList();
    }
    throw Exception(response['message'] ?? 'Failed to load options');
  }

  static Future<Map<String, dynamic>> getNonContributionList({
    String? name,
    int? categoryId,
    String? from,
    String? to,
    int page = 1,
  }) async {
    final queryParams = <String, String>{};
    queryParams['page'] = page.toString();
    if (name != null && name.isNotEmpty) {
      queryParams['filter[name]'] = name;
    }
    if (categoryId != null) {
      queryParams['filter[income_category_id]'] = categoryId.toString();
    }
    if (from != null && from.isNotEmpty) {
      queryParams['filter[from]'] = from;
    }
    if (to != null && to.isNotEmpty) {
      queryParams['filter[to]'] = to;
    }

    final uri = Uri.parse(
      IncomeApiConstant.nonContributionList,
    ).replace(queryParameters: queryParams);
    final response = await ApiService.get(uri.toString());

    if (response['success'] == true && response['data'] != null) {
      final data = response['data'];
      final itemsRaw = data is Map<String, dynamic>
          ? _extractList(data['data'])
          : _extractList(data);
      final list = itemsRaw
          .map((e) => IncomeNonContributionModel.fromJson(e))
          .toList();
      final pagination =
          data is Map<String, dynamic> &&
              (data['links'] != null || data['meta'] != null)
          ? data
          : null;

      return {'success': true, 'incomes': list, 'pagination': pagination};
    }
    throw Exception(
      response['message'] ?? 'Failed to load non-contribution incomes',
    );
  }

  static Future<IncomeNonContributionDetailModel> getNonContributionDetail(
    int id,
  ) async {
    final response = await ApiService.get(
      '${IncomeApiConstant.nonContributionDetail}$id',
    );
    if (response['success'] == true && response['data'] != null) {
      return IncomeNonContributionDetailModel.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    }
    throw Exception(response['message'] ?? 'Failed to load details');
  }

  static Future<Map<String, dynamic>> storeNonContributionIncome({
    required String name,
    required int categoryId,
    required int amount,
    required String happenedAt,
    File? proofFile,
  }) async {
    final fields = {
      'name': name,
      'income_category_id': categoryId.toString(),
      'amount': amount.toString(),
      'happened_at': happenedAt,
    };

    final files = <String, File>{};
    if (proofFile != null) {
      files['file_path'] = proofFile;
    }

    return await ApiService.postMultipart(
      IncomeApiConstant.nonContributionStore,
      fields: fields,
      files: files,
    );
  }
}
