import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/controllers/midtrans_payment_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransPaymentScreen extends GetView<MidtransController> {
  const MidtransPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitConfirmation(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pembayaran'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _showExitConfirmation(context),
          ),
          actions: [
            Obx(
              () => controller.isChecking.value
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Cek Status Pembayaran',
                      onPressed: () =>
                          controller.checkPaymentStatus(isFinalCheck: false),
                    ),
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller.webViewController),

            Obx(
              () => controller.isLoading.value
                  ? Container(
                      color: AppColor.surface.withValues(alpha: 0.7),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),

                            SizedBox(height: 16),

                            Text(
                              'Memuat halaman pembayaran...',
                              style: AppTextStyle.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Bottom status checking indicator
            Obx(
              () => controller.isChecking.value
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        color: AppColor.primaryLight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),

                            SizedBox(width: 12),

                            Text(
                              'Memeriksa status pembayaran...',
                              style: AppTextStyle.bodySmall.copyWith(
                                color: AppColor.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Keluar dari Pembayaran?'),
        content: const Text(
          'Jika Anda keluar sekarang, Anda masih bisa melanjutkan pembayaran dari halaman pesanan selama belum kedaluwarsa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tetap di Sini'),
          ),

          TextButton(
            onPressed: () {
              Get.back();
              Get.back(result: 'pending');
            },

            child: Text(
              'Keluar',
              style: AppTextStyle.labelLarge.copyWith(color: AppColor.error),
            ),
          ),
        ],
      ),
    );
  }
}
