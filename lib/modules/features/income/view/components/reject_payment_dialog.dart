import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/income/controllers/income_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class RejectPaymentDialog extends StatefulWidget {
  const RejectPaymentDialog({required this.billId, super.key});

  final int billId;

  @override
  State<RejectPaymentDialog> createState() => _RejectPaymentDialogState();
}

class _RejectPaymentDialogState extends State<RejectPaymentDialog> {
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = IncomeController.to;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Tolak Pembayaran'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Silakan berikan alasan penolakan agar warga dapat mengetahuinya.',
            style: TextStyle(fontSize: 13, color: AppColor.textSecondary),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _reasonController,
            decoration: const InputDecoration(
              hintText: 'Cth: Bukti transfer tidak terbaca / nominal kurang...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              fillColor: AppColor.inputFill,
              filled: true,
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Batal',
            style: TextStyle(color: AppColor.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () => controller.rejectBillPayment(
            widget.billId,
            _reasonController.text,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.error,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Tolak', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
