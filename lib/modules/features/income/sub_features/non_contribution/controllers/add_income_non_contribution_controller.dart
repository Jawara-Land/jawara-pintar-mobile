import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/modules/features/income/models/income_category_model.dart';

class AddIncomeNonContributionController extends GetxController {
  final IncomeController incomeController = IncomeController.to;

  final nameController = TextEditingController();
  final amountController = TextEditingController();

  final Rxn<IncomeCategoryModel> selectedCategory = Rxn<IncomeCategoryModel>();
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rxn<File> proofFile = Rxn<File>();

  @override
  void onClose() {
    nameController.dispose();
    amountController.dispose();
    super.onClose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Kamera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await picker.pickImage(
        imageQuality: 70,
        source: source,
      );
      if (pickedFile != null) {
        proofFile.value = File(pickedFile.path);
      }
    }
  }

  void submitForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate() && selectedCategory.value != null) {
      final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      incomeController.storeNonContribution(
        name: nameController.text.trim(),
        categoryId: selectedCategory.value!.id,
        amount: int.parse(amountController.text),
        happenedAt: formatter.format(selectedDate.value),
        proofFile: proofFile.value,
      );
    }
  }
}
