import 'dart:io';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';
import '../../../constants/income_api_constant.dart';
import '../../../models/family_contribution_model.dart';
import '../../../models/transfer_channel_model.dart';

class ResidentBillRepository {
  ResidentBillRepository._();

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

  static Future<List<FamilyContributionModel>> getResidentBills() async {
    final response = await ApiService.get(IncomeApiConstant.residentBillsList);
    if (response['success'] == true && response['data'] != null) {
      final list = _extractList(
        response['data'] is Map<String, dynamic>
            ? response['data']['data'] ?? response['data']
            : response['data'],
      );
      return list.map((e) => FamilyContributionModel.fromJson(e)).toList();
    }
    throw Exception(response['message'] ?? 'Failed to load family bills');
  }

  static Future<FamilyContributionModel> getResidentBillDetail(int id) async {
    final response = await ApiService.get(
      '${IncomeApiConstant.residentBillDetail}$id',
    );
    if (response['success'] == true && response['data'] != null) {
      return FamilyContributionModel.fromJson(
        Map<String, dynamic>.from(response['data'] as Map),
      );
    }
    throw Exception(response['message'] ?? 'Failed to load bill detail');
  }

  static Future<Map<String, dynamic>> getMidtransToken(int id) async {
    return await ApiService.post(IncomeApiConstant.getPaymentToken, {
      'family_contribution_id': id,
    });
  }

  static Future<Map<String, dynamic>> updateStatusAfterPayment(
    int id, {
    required String status,
  }) async {
    return await ApiService.post(
      '${IncomeApiConstant.updateStatusAfterPayment}$id/update-status',
      {'status': status},
    );
  }

  static Future<Map<String, dynamic>> updateStatusAfterTransfer(
    int id, {
    required String channelCode,
  }) async {
    return await ApiService.post(
      '${IncomeApiConstant.updateStatusAfterTransfer}$id/update-status-after-transfer',
      {'channel_code': channelCode},
    );
  }

  static Future<Map<String, dynamic>> uploadPaymentProof(
    int id,
    File file,
  ) async {
    final fields = <String, String>{};
    final files = {'payment_proof': file};
    return await ApiService.postMultipart(
      '${IncomeApiConstant.uploadProof}$id/upload-proof',
      fields: fields,
      files: files,
    );
  }

  static Future<List<TransferChannelModel>> getTransferChannels() async {
    final response = await ApiService.get(IncomeApiConstant.transferChannels);
    if (response['success'] == true && response['data'] != null) {
      final list = _extractList(response['data']);
      return list.map((e) => TransferChannelModel.fromJson(e)).toList();
    }
    throw Exception(response['message'] ?? 'Failed to load transfer channels');
  }
}
