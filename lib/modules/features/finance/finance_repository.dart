import 'package:jawara_mobile/shared/models/base_response.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';

import 'finance_api_constant.dart';

class FinanceRepository {
  Future<List<Map<String, dynamic>>> getAllIncomes() async {
    final response = await ApiService.get(FinanceApiConstant.incomes);
    if (response['_statusCode'] == 200 && response['success'] == true) {
      final List dataList = response['data']['data'] ?? response['data'] ?? [];
      return dataList.cast<Map<String, dynamic>>();
    }
    throw Exception(response['message'] ?? 'Failed to fetch incomes');
  }

  Future<List<Map<String, dynamic>>> getAllExpenses() async {
    final response = await ApiService.get(FinanceApiConstant.expenses);
    if (response['_statusCode'] == 200 && response['success'] == true) {
      final List dataList = response['data']['data'] ?? response['data'] ?? [];
      return dataList.cast<Map<String, dynamic>>();
    }
    throw Exception(response['message'] ?? 'Failed to fetch expenses');
  }

  Future<BaseResponse<Map<String, dynamic>>> getDashboard() async {
    final response = await ApiService.get(FinanceApiConstant.dashboard);
    final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
      response,
      fromJsonT: (data) => data,
    );

    if (baseResponse.success) return baseResponse;
    throw Exception(baseResponse.message);
  }

  Future<BaseResponse<Map<String, dynamic>>> getSummary() async {
    final response = await ApiService.get(FinanceApiConstant.summary);
    final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
      response,
      fromJsonT: (data) => data,
    );

    if (baseResponse.success) return baseResponse;
    throw Exception(baseResponse.message);
  }

  Future<Map<String, dynamic>> getReport({
    required String type,
    required String start,
    required String end,
  }) async {
    final response = await ApiService.get(
      '${FinanceApiConstant.report}?type=$type&start_date=$start&end_date=$end',
    );
    if (response['_statusCode'] == 200 && response['success'] == true) {
      return response['data'] as Map<String, dynamic>? ?? {};
    }
    throw Exception(response['message'] ?? 'Failed to fetch report');
  }

  Future<Map<String, dynamic>> downloadReport({
    required String type,
    required String start,
    required String end,
  }) async {
    final response = await ApiService.get(
      '${FinanceApiConstant.reportDownload}?type=$type&start_date=$start&end_date=$end',
    );
    if (response['_statusCode'] == 200 && response['success'] == true) {
      return response;
    }
    throw Exception(response['message'] ?? 'Failed to download report');
  }
}
