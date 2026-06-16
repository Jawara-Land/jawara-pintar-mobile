import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/models/order_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/repositories/order_repository.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/cart/controllers/cart_controller.dart';

class OrderController extends GetxController {
  final RxList<OrderModel> buyerOrders = <OrderModel>[].obs;
  final RxList<OrderModel> sellerOrders = <OrderModel>[].obs;

  final RxBool isLoadingBuyer = false.obs;
  final RxBool isLoadingSeller = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBuyerOrders();
  }

  Future<void> onRefresh() async {
    await fetchBuyerOrders();
  }

  Future<void> fetchBuyerOrders({String? status}) async {
    isLoadingBuyer.value = true;
    try {
      final response = await OrderRepository.getOrders(status: status);
      if (response['success'] == true) {
        final List data = response['data']['orders'] ?? [];
        buyerOrders.value = data.map((e) => OrderModel.fromJson(e)).toList();
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Gagal memuat pesanan: $e');
    } finally {
      isLoadingBuyer.value = false;
    }
  }

  Future<void> fetchSellerOrders({String? status}) async {
    isLoadingSeller.value = true;
    try {
      final response = await OrderRepository.getSellerOrders(status: status);
      if (response['success'] == true) {
        final List data = response['data']['orders'] ?? [];
        sellerOrders.value = data.map((e) => OrderModel.fromJson(e)).toList();
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Gagal memuat pesanan toko: $e');
    } finally {
      isLoadingSeller.value = false;
    }
  }

  Future<void> processCheckout({
    required String deliveryMethod,
    required List<int> cartItemIds,
    int? addressId,
    String? notes,
  }) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await OrderRepository.checkout(
        deliveryMethod: deliveryMethod,
        cartItemIds: cartItemIds,
        addressId: addressId,
        notes: notes,
      );

      Get.back();

      if (response['success'] == true) {
        try {
          Get.find<CartController>().fetchCart();
        } catch (_) {}

        final List ordersData = response['data']['orders'] ?? [];
        if (ordersData.isEmpty) {
          Get.snackbar('Sukses', 'Pesanan berhasil dibuat');
          Get.offAllNamed(Routes.mainRoute);
          return;
        }

        bool anyPaymentSuccess = false;
        bool anyPaymentPending = false;

        for (final orderJson in ordersData) {
          final order = OrderModel.fromJson(orderJson);
          final paymentResult = await _openMidtransPayment(order);

          if (paymentResult == true) {
            anyPaymentSuccess = true;
          } else if (paymentResult == 'pending') {
            anyPaymentPending = true;
          }
        }

        if (anyPaymentSuccess) {
          Get.snackbar('Sukses', 'Pembayaran berhasil diselesaikan');
        } else if (anyPaymentPending) {
          Get.snackbar(
            'Info',
            'Pembayaran pending, silakan cek berkala di halaman pesanan',
          );
        }

        fetchBuyerOrders();
        Get.offAllNamed(Routes.mainRoute);
      } else {
        Get.snackbar('Error', response['message'] ?? 'Gagal membuat pesanan');
      }
    } catch (e, stackTrace) {
      if (Get.isDialogOpen ?? false) Get.back();
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  Future<dynamic> _openMidtransPayment(OrderModel order) async {
    if (order.midtransSnapToken == null || order.midtransSnapToken!.isEmpty) {
      Get.snackbar(
        'Error',
        'Token pembayaran tidak tersedia untuk pesanan ${order.orderNumber}',
      );
      return null;
    }

    final snapUrl =
        order.midtransRedirectUrl ??
        'https://app.sandbox.midtrans.com/snap/v2/vtweb/${order.midtransSnapToken}';

    final result = await Get.toNamed(
      Routes.midtransPaymentRoute,
      arguments: {'url': snapUrl, 'order_id': order.id},
    );

    return result;
  }

  Future<void> payOrder(OrderModel order) async {
    final result = await _openMidtransPayment(order);

    if (result == true) {
      Get.snackbar('Sukses', 'Pembayaran berhasil diselesaikan');
    } else if (result == 'pending') {
      Get.snackbar('Info', 'Pembayaran pending, silakan cek berkala');
    } else if (result == false) {
      Get.snackbar('Error', 'Pembayaran gagal atau dibatalkan');
    }

    fetchBuyerOrders();
  }

  Future<void> updateOrderStatus(
    int orderId,
    String status, {
    String? cancelReason,
  }) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await OrderRepository.updateOrderStatus(
        orderId,
        status,
        cancelReason: cancelReason,
      );

      Get.back();

      if (response['success'] == true) {
        Get.snackbar('Sukses', 'Status pesanan diperbarui');
        fetchBuyerOrders();
        fetchSellerOrders();
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Gagal memperbarui status',
        );
      }
    } catch (e, stackTrace) {
      if (Get.isDialogOpen ?? false) Get.back();
      Sentry.captureException(e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
