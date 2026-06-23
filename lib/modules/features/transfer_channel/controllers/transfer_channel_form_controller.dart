import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../controllers/transfer_channel_controller.dart';
import '../models/transfer_channel_model.dart';
import '../repositories/transfer_channel_repository.dart';

class TransferChannelFormController extends GetxController {
  final TransferChannelRepository _repository = TransferChannelRepository();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final accountController = TextEditingController();
  final holderController = TextEditingController();
  final noteController = TextEditingController();

  final selectedType = 'bank'.obs;
  final thumbnailFile = Rx<File?>(null);
  final qrImageFile = Rx<File?>(null);
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;

  final _picker = ImagePicker();

  static const channelTypes = ['bank', 'ewallet', 'qris'];

  TransferChannel? editChannel;
  bool isEditing = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is TransferChannel) {
      editChannel = Get.arguments as TransferChannel;
      isEditing = true;
      _populateFromChannel(editChannel!);
    }
  }

  void _populateFromChannel(TransferChannel channel) {
    nameController.text = channel.name;
    accountController.text = channel.accountNumber ?? '';
    holderController.text = channel.holderName ?? '';
    noteController.text = channel.note ?? '';
    selectedType.value = channel.type;
  }

  Future<void> pickImage({required bool isThumbnail}) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      if (isThumbnail) {
        thumbnailFile.value = File(image.path);
      } else {
        qrImageFile.value = File(image.path);
      }
    }
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    final name = nameController.text.trim();
    final type = selectedType.value;
    final accountNumber = accountController.text.trim();
    final holderName = holderController.text.trim();
    final note = noteController.text.trim();

    try {
      isSubmitting(true);
      errorMessage('');

      if (isEditing) {
        await _repository.updateTransferChannel(
          id: editChannel!.id,
          name: name,
          type: type,
          accountNumber: accountNumber.isEmpty ? null : accountNumber,
          holderName: holderName.isEmpty ? null : holderName,
          note: note.isEmpty ? null : note,
          thumbnail: thumbnailFile.value,
          qrImage: qrImageFile.value,
        );
      } else {
        await _repository.createTransferChannel(
          name: name,
          type: type,
          accountNumber: accountNumber.isEmpty ? null : accountNumber,
          holderName: holderName.isEmpty ? null : holderName,
          note: note.isEmpty ? null : note,
          thumbnail: thumbnailFile.value,
          qrImage: qrImageFile.value,
        );
      }

      if (Get.isRegistered<TransferChannelController>()) {
        await Get.find<TransferChannelController>().fetchChannels();
      }

      return true;
    } catch (e, stackTrace) {
      errorMessage(e.toString());
      await Sentry.captureException(e, stackTrace: stackTrace);
      return false;
    } finally {
      isSubmitting(false);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    accountController.dispose();
    holderController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
