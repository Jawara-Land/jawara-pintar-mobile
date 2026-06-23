import 'dart:io';

import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../models/transfer_channel_model.dart';
import '../repositories/transfer_channel_repository.dart';

class TransferChannelController extends GetxController {
  final TransferChannelRepository _repository = TransferChannelRepository();

  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var errorMessage = ''.obs;
  var channels = <TransferChannel>[].obs;
  var selectedChannel = Rx<TransferChannel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchChannels();
  }

  Future<void> fetchChannels({String? name}) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repository.getTransferChannels(name: name);
      channels.assignAll(result);
    } catch (e, stackTrace) {
      errorMessage(e.toString());
      await Sentry.captureException(e, stackTrace: stackTrace);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchChannelDetail(int id) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repository.getTransferChannelDetail(id);
      selectedChannel.value = result;
    } catch (e, stackTrace) {
      errorMessage(e.toString());
      await Sentry.captureException(e, stackTrace: stackTrace);
    } finally {
      isLoading(false);
    }
  }

  Future<bool> createChannel({
    required String name,
    required String type,
    String? accountNumber,
    String? holderName,
    String? note,
    File? thumbnail,
    File? qrImage,
  }) async {
    try {
      isSubmitting(true);
      errorMessage('');
      await _repository.createTransferChannel(
        name: name,
        type: type,
        accountNumber: accountNumber,
        holderName: holderName,
        note: note,
        thumbnail: thumbnail,
        qrImage: qrImage,
      );
      await fetchChannels();
      return true;
    } catch (e, stackTrace) {
      errorMessage(e.toString());
      await Sentry.captureException(e, stackTrace: stackTrace);
      return false;
    } finally {
      isSubmitting(false);
    }
  }

  Future<bool> updateChannel({
    required int id,
    required String name,
    required String type,
    String? accountNumber,
    String? holderName,
    String? note,
    File? thumbnail,
    File? qrImage,
  }) async {
    try {
      isSubmitting(true);
      errorMessage('');
      await _repository.updateTransferChannel(
        id: id,
        name: name,
        type: type,
        accountNumber: accountNumber,
        holderName: holderName,
        note: note,
        thumbnail: thumbnail,
        qrImage: qrImage,
      );
      await fetchChannels();
      return true;
    } catch (e, stackTrace) {
      errorMessage(e.toString());
      await Sentry.captureException(e, stackTrace: stackTrace);
      return false;
    } finally {
      isSubmitting(false);
    }
  }

  Future<bool> deleteChannel(int id) async {
    try {
      isSubmitting(true);
      errorMessage('');
      await _repository.deleteTransferChannel(id);
      channels.removeWhere((c) => c.id == id);
      return true;
    } catch (e, stackTrace) {
      errorMessage(e.toString());
      await Sentry.captureException(e, stackTrace: stackTrace);
      return false;
    } finally {
      isSubmitting(false);
    }
  }
}
