import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/controllers/order_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/models/order_model.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class OrderDetailScreen extends GetView<OrderController> {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderModel order = Get.arguments?['order'];
    final String role = Get.arguments?['role'] ?? 'buyer';

    int subtotal = order.subtotal;
    if (subtotal == 0 && order.items != null) {
      subtotal = order.items!.fold(0, (sum, item) => sum + item.subtotal);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppColor.primaryLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: ${order.statusLabel}',
                    style: AppTextStyle.titleLarge,
                  ),

                  SizedBox(height: 4),

                  Text('No Pesanan: ${order.orderNumber}'),

                  Text(
                    'Tanggal: ${order.createdAt?.toLocal().toString().split('.')[0] ?? '-'}',
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            Text('Produk', style: AppTextStyle.titleLarge),

            Divider(),

            if (order.items != null)
              ...order.items!
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.productName} x${item.quantity}',
                            ),
                          ),
                          CurrencyText(item.subtotal),
                        ],
                      ),
                    ),
                  )
                  .toList(),

            Divider(height: 32),

            Text('Rincian Pembayaran', style: AppTextStyle.titleLarge),

            SizedBox(height: 8),

            PriceRow(label: 'Subtotal Produk', amount: subtotal),

            PriceRow(label: 'Ongkos Kirim', amount: order.shippingCost),

            PriceRow(label: 'Biaya Layanan', amount: order.serviceFee),

            Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Belanja', style: AppTextStyle.titleLarge),

                CurrencyText(
                  order.totalAmount,
                  style: AppTextStyle.titleLarge.copyWith(
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            Text('Info Pengiriman', style: AppTextStyle.titleLarge),

            Text('Metode: ${order.deliveryMethod}'),

            if (order.address != null)
              Text('Alamat: ${order.address!.address}')
            else if (order.shippingAddress != null)
              Text('Alamat: ${order.shippingAddress}'),
            if (order.notes != null && order.notes!.isNotEmpty)
              Text('Catatan: ${order.notes}'),

            SizedBox(height: 32),

            // Buyer Actions
            if (role == 'buyer') ...[
              if (order.status == 'pending')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.payOrder(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.success,
                    ),
                    child: Text(
                      'Bayar Sekarang (Midtrans)',
                      style: AppTextStyle.labelLarge.copyWith(
                        color: AppColor.textOnPrimary,
                      ),
                    ),
                  ),
                ),

              if (order.status == 'shipped' || order.status == 'picked_up')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.updateOrderStatus(order.id, 'completed'),
                    child: const Text('Pesanan Telah Diterima / Selesai'),
                  ),
                ),

              if (order.status == 'pending')
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => controller.updateOrderStatus(
                        order.id,
                        'cancelled',
                        cancelReason: 'Dibatalkan oleh pembeli',
                      ),
                      child: Text(
                        'Batalkan Pesanan',
                        style: AppTextStyle.labelLarge.copyWith(
                          color: AppColor.error,
                        ),
                      ),
                    ),
                  ),
                ),
            ],

            // Seller Actions
            if (role == 'seller') ...[
              if (order.status == 'paid')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.updateOrderStatus(order.id, 'processed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                    ),
                    child: Text(
                      'Proses Pesanan',
                      style: AppTextStyle.labelLarge.copyWith(
                        color: AppColor.textOnPrimary,
                      ),
                    ),
                  ),
                ),

              if (order.status == 'processed')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.updateOrderStatus(
                      order.id,
                      order.deliveryMethod == 'pickup'
                          ? 'picked_up'
                          : 'shipped',
                    ),
                    child: Text(
                      order.deliveryMethod == 'pickup'
                          ? 'Siap Diambil'
                          : 'Kirim Pesanan',
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
