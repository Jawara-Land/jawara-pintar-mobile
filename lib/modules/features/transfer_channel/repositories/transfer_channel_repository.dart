import 'dart:io';

import 'package:jawara_mobile/shared/utils/services/api_service.dart';
import '../constants/transfer_channel_api_constant.dart';
import '../models/transfer_channel_model.dart';

class TransferChannelRepository {
  Future<List<TransferChannel>> getTransferChannels({
    int page = 1,
    String? name,
  }) async {
    final queryParams = <String>['page=$page'];
    if (name != null && name.isNotEmpty) {
      queryParams.add('filter[name]=$name');
    }
    final queryString = '?${queryParams.join('&')}';
    final url = '${TransferChannelApiConstant.transferChannels}$queryString';

    final response = await ApiService.get(url);
    if (response['_statusCode'] == 200 && response['success'] == true) {
      final List dataList = response['data']['data'] ?? [];
      return dataList.map((e) => TransferChannel.fromJson(e)).toList();
    }
    throw Exception(
      response['message'] ?? 'Gagal memuat daftar transfer channel',
    );
  }

  Future<TransferChannel> getTransferChannelDetail(int id) async {
    final response = await ApiService.get(
      '${TransferChannelApiConstant.transferChannels}/$id',
    );
    if (response['_statusCode'] == 200 && response['success'] == true) {
      return TransferChannel.fromJson(response['data']);
    }
    throw Exception(
      response['message'] ?? 'Gagal memuat detail transfer channel',
    );
  }

  Future<TransferChannel> createTransferChannel({
    required String name,
    required String type,
    String? accountNumber,
    String? holderName,
    String? note,
    File? thumbnail,
    File? qrImage,
  }) async {
    final fields = <String, String>{
      'name': name,
      'type': type,
      if (accountNumber != null && accountNumber.isNotEmpty)
        'account_number': accountNumber,
      if (holderName != null && holderName.isNotEmpty)
        'holder_name': holderName,
      if (note != null && note.isNotEmpty) 'note': note,
    };

    final files = <String, File>{
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (qrImage != null) 'qr_image': qrImage,
    };

    final Map<String, dynamic> response;
    if (files.isNotEmpty) {
      response = await ApiService.postMultipart(
        TransferChannelApiConstant.transferChannels,
        fields: fields,
        files: files,
      );
    } else {
      response = await ApiService.post(
        TransferChannelApiConstant.transferChannels,
        fields,
      );
    }

    if ((response['_statusCode'] == 200 || response['_statusCode'] == 201) &&
        response['success'] == true) {
      return TransferChannel.fromJson(response['data']);
    }
    throw Exception(response['message'] ?? 'Gagal membuat transfer channel');
  }

  Future<TransferChannel> updateTransferChannel({
    required int id,
    required String name,
    required String type,
    String? accountNumber,
    String? holderName,
    String? note,
    File? thumbnail,
    File? qrImage,
  }) async {
    final fields = <String, String>{
      'name': name,
      'type': type,
      if (accountNumber != null && accountNumber.isNotEmpty)
        'account_number': accountNumber,
      if (holderName != null && holderName.isNotEmpty)
        'holder_name': holderName,
      if (note != null && note.isNotEmpty) 'note': note,
    };

    final files = <String, File>{
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (qrImage != null) 'qr_image': qrImage,
    };

    final response = await ApiService.postMultipart(
      '${TransferChannelApiConstant.transferChannels}/$id',
      fields: fields,
      files: files,
    );

    if (response['_statusCode'] == 200 && response['success'] == true) {
      return TransferChannel.fromJson(response['data']);
    }
    throw Exception(
      response['message'] ?? 'Gagal memperbarui transfer channel',
    );
  }

  Future<void> deleteTransferChannel(int id) async {
    final response = await ApiService.delete(
      '${TransferChannelApiConstant.transferChannels}/$id',
    );
    if (response['_statusCode'] != 200 || response['success'] != true) {
      throw Exception(
        response['message'] ?? 'Gagal menghapus transfer channel',
      );
    }
  }
}
