import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/repositories/order_repository.dart';

class MidtransController extends GetxController {
  late WebViewController webViewController;

  late final String url;
  late final int orderId;

  var isLoading = true.obs;
  var isChecking = false.obs;

  // Tracks the payment paid/cancelled
  bool _hasFinalized = false;

  Timer? _autoCheckTimer;

  // Count of consecutive polling failures — stop auto-check if too many.
  int _failureCount = 0;
  static const int _maxFailures = 5;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    url = args['url'] as String? ?? '';
    orderId = args['order_id'] as int? ?? 0;

    if (url.isEmpty) {
      Get.snackbar('Error', 'URL pembayaran tidak tersedia');
      Get.back(result: false);
      return;
    }

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => isLoading.value = true,
          onPageFinished: (_) => isLoading.value = false,
          onWebResourceError: (error) {
            isLoading.value = false;
            debugPrint('WebView error: ${error.description}');
          },
          onNavigationRequest: (request) {
            final requestUrl = request.url.toLowerCase();

            if (requestUrl.contains('/snap/') &&
                requestUrl.contains('#/status')) {
              Future.delayed(const Duration(seconds: 2), () {
                checkPaymentStatus(isFinalCheck: false);
              });
            }

            if (requestUrl.contains('midtrans-finish') ||
                requestUrl.contains('payment/finish')) {
              _onMidtransFinish();
              return NavigationDecision.prevent;
            }
            if (requestUrl.contains('midtrans-unfinish') ||
                requestUrl.contains('payment/unfinish')) {
              _onMidtransPending();
              return NavigationDecision.prevent;
            }
            if (requestUrl.contains('midtrans-error') ||
                requestUrl.contains('payment/error')) {
              _onMidtransError();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    if (orderId > 0) {
      _startAutoCheck();
    }
  }

  void _onMidtransFinish() {
    if (_hasFinalized) return;
    checkPaymentStatus(isFinalCheck: true);
  }

  void _onMidtransPending() {
    if (_hasFinalized) return;
    _hasFinalized = true;
    _stopAutoCheck();
    Get.back(result: 'pending');
  }

  void _onMidtransError() {
    if (_hasFinalized) return;
    _hasFinalized = true;
    _stopAutoCheck();
    Get.back(result: false);
  }

  Future<void> checkPaymentStatus({bool isFinalCheck = false}) async {
    if (_hasFinalized || orderId <= 0) return;

    try {
      isChecking.value = true;
      _failureCount = 0; // reset on attempt

      final response = await OrderRepository.getOrderDetail(orderId);

      if (response['success'] == true) {
        final orderData = response['data']?['order'];
        if (orderData == null) return;

        final String status = orderData['status'] as String? ?? '';
        final paymentData = orderData['payment'];
        final String transactionStatus =
            paymentData?['transaction_status'] as String? ?? '';

        // Check if payment is confirmed via order status
        if (status == 'paid' ||
            status == 'processed' ||
            status == 'shipped' ||
            status == 'picked_up' ||
            status == 'completed') {
          _hasFinalized = true;
          _stopAutoCheck();
          Get.back(result: true);
          return;
        }

        // Check Midtrans transaction status from payment record
        if (transactionStatus == 'settlement' ||
            transactionStatus == 'capture') {
          _hasFinalized = true;
          _stopAutoCheck();
          Get.back(result: true);
          return;
        }

        // Check if cancelled/expired
        if (status == 'cancelled' ||
            transactionStatus == 'cancel' ||
            transactionStatus == 'deny' ||
            transactionStatus == 'expire') {
          _hasFinalized = true;
          _stopAutoCheck();
          Get.back(result: false);
          return;
        }

        if (isFinalCheck && status == 'pending') {
          await Future.delayed(const Duration(seconds: 3));
          final retryResponse = await OrderRepository.getOrderDetail(orderId);
          if (retryResponse['success'] == true) {
            final retryStatus =
                retryResponse['data']?['order']?['status'] as String? ?? '';
            if (retryStatus == 'paid' || retryStatus == 'processed') {
              _hasFinalized = true;
              _stopAutoCheck();
              Get.back(result: true);
              return;
            }
          }

          _hasFinalized = true;
          _stopAutoCheck();
          Get.back(result: 'pending');
          return;
        }
      }
    } catch (e, stackTrace) {
      _failureCount++;
      Sentry.captureException(e, stackTrace: stackTrace);
      debugPrint('Error checking payment status: $e');

      // Stop auto-check after too many consecutive failures
      if (_failureCount >= _maxFailures) {
        _stopAutoCheck();
        Get.snackbar(
          'Peringatan',
          'Gagal memeriksa status pembayaran. Silakan cek pesanan Anda.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isChecking.value = false;
    }
  }

  void _startAutoCheck() {
    _autoCheckTimer?.cancel();
    _autoCheckTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      checkPaymentStatus();
    });
  }

  void _stopAutoCheck() {
    _autoCheckTimer?.cancel();
    _autoCheckTimer = null;
  }

  @override
  void onClose() {
    _stopAutoCheck();
    super.onClose();
  }
}
