import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/aspiration/controllers/aspiration_controller.dart';
import 'package:jawara_mobile/modules/features/aspiration/models/aspiration_model.dart';

class AspirationFormScreen extends StatefulWidget {
  const AspirationFormScreen({super.key, this.existing});

  final AspirationModel? existing;

  @override
  State<AspirationFormScreen> createState() => _AspirationFormScreenState();
}

class _AspirationFormScreenState extends State<AspirationFormScreen> {
  final controller = Get.find<AspirationController>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.existing?.title ?? '');
    descriptionController = TextEditingController(
      text: widget.existing?.description ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Ubah Pesan Warga' : 'Buat Pesan Warga'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Isi pesan'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (isEdit) {
                  await controller.updateAspiration(
                    widget.existing!.id,
                    titleController.text,
                    descriptionController.text,
                  );
                } else {
                  await controller.createAspiration(
                    titleController.text,
                    descriptionController.text,
                  );
                }
                Get.back(result: true);
              },
              child: Text(isEdit ? 'Simpan' : 'Kirim'),
            ),
          ],
        ),
      ),
    );
  }
}
