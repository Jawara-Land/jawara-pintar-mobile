import 'package:jawara_mobile/shared/utils/services/api_service.dart';
import '../../../constants/income_api_constant.dart';
import '../../../models/contribution_category_model.dart';
import '../../../models/family_contribution_model.dart';
import '../../../models/bill_history_group_model.dart';

class TreasurerBillRepository {
  TreasurerBillRepository._();

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

  static Future<List<ContributionCategoryModel>>
  getContributionCategoriesOptions() async {
    final response = await ApiService.get(
      IncomeApiConstant.contributionCategoriesOptions,
    );
    if (response['success'] == true && response['data'] != null) {
      final list = _extractList(response['data']);
      return list.map((e) => ContributionCategoryModel.fromJson(e)).toList();
    }
    throw Exception(
      response['message'] ?? 'Failed to load contribution category options',
    );
  }

  static Future<List<ContributionCategoryModel>>
  getContributionCategories() async {
    final response = await ApiService.get(
      IncomeApiConstant.contributionCategories,
    );
    if (response['success'] == true && response['data'] != null) {
      final data = response['data'];
      final list = _extractList(
        data is Map<String, dynamic> ? data['data'] ?? data : data,
      );
      return list.map((e) => ContributionCategoryModel.fromJson(e)).toList();
    }
    throw Exception(
      response['message'] ?? 'Failed to load contribution categories',
    );
  }

  static Future<Map<String, dynamic>> storeContributionCategory({
    required String name,
    required int amount,
    required int contributionCategoryId,
  }) async {
    return await ApiService.post(IncomeApiConstant.contributionCategories, {
      'name': name,
      'amount': amount,
      'contribution_category_id': contributionCategoryId,
    });
  }

  static Future<Map<String, dynamic>> assignBills({
    required int contributionId,
    required List<int> familyIds,
    required String month,
  }) async {
    return await ApiService.post(IncomeApiConstant.assignBills, {
      'contribution_id': contributionId,
      'family_ids': familyIds,
      'month': month,
    });
  }

  static Future<List<BillHistoryGroupModel>> getBillsHistory() async {
    final response = await ApiService.get(IncomeApiConstant.billsHistory);
    if (response['success'] == true && response['data'] != null) {
      final data = response['data'];
      final list = _extractList(
        data is Map<String, dynamic> ? data['data'] ?? data : data,
      );
      return list.map((e) => BillHistoryGroupModel.fromJson(e)).toList();
    }
    throw Exception(response['message'] ?? 'Failed to load assignment history');
  }

  static Future<Map<String, dynamic>> getAssignedFamilies(String code) async {
    final response = await ApiService.get(
      '${IncomeApiConstant.assignedFamilies}$code',
    );
    if (response['success'] == true && response['data'] != null) {
      final List list = _extractList(
        response['data'] is Map<String, dynamic>
            ? response['data']['families']
            : response['data'],
      );
      return {
        'success': true,
        'families': list
            .map((e) => FamilyContributionModel.fromJson(e))
            .toList(),
      };
    }
    throw Exception(
      response['message'] ?? 'Failed to load assigned families detail',
    );
  }

  static Future<Map<String, dynamic>> getBillsList({
    String? familyName,
    int? contributionCategoryId,
    String? status,
    int page = 1,
  }) async {
    final queryParams = <String, String>{};
    queryParams['page'] = page.toString();
    if (familyName != null && familyName.isNotEmpty) {
      queryParams['filter[family_name]'] = familyName;
    }
    if (contributionCategoryId != null) {
      queryParams['filter[contribution_category_id]'] = contributionCategoryId
          .toString();
    }
    if (status != null && status.isNotEmpty) {
      queryParams['filter[status]'] = status;
    }

    final uri = Uri.parse(
      IncomeApiConstant.billsList,
    ).replace(queryParameters: queryParams);
    final response = await ApiService.get(uri.toString());

    if (response['success'] == true && response['data'] != null) {
      final data = response['data'];
      final itemsRaw = data is Map<String, dynamic>
          ? _extractList(data['data'] ?? data['bills'] ?? data)
          : _extractList(data);
      final list = itemsRaw
          .map((e) => FamilyContributionModel.fromJson(e))
          .toList();
      final pagination = data is Map<String, dynamic>
          ? (data['pagination'] as Map<String, dynamic>? ??
                (data['links'] != null || data['meta'] != null ? data : null))
          : null;

      return {'success': true, 'bills': list, 'pagination': pagination};
    }
    throw Exception(response['message'] ?? 'Failed to load bills');
  }

  static Future<Map<String, dynamic>> approvePayment(int id) async {
    return await ApiService.put(
      '${IncomeApiConstant.approvePayment}$id/approve',
      {},
    );
  }

  static Future<Map<String, dynamic>> rejectPayment(
    int id, {
    required String reason,
  }) async {
    return await ApiService.put(
      '${IncomeApiConstant.rejectPayment}$id/reject',
      {'rejected_reason': reason},
    );
  }
}
