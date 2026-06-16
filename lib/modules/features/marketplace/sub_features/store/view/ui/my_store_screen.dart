import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/controllers/store_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/view/components/menu_card.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/view/components/order_card.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/view/components/performa_card.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/view/components/section_title.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/view/components/store_profile_card.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class MyStoreScreen extends GetView<StoreController> {
  const MyStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toko Saya')),
      body: Obx(() {
        if (controller.isLoadingStore.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.store.value == null) {
          return ListView(
            children: [
              AppEmptyState(
                icon: Icons.storefront,
                message: 'Anda belum memiliki toko',
                actionLabel: 'Buka Toko Sekarang',
                onAction: () => Get.toNamed(Routes.createStoreRoute),
              ),
            ],
          );
        }

        final store = controller.store.value!;
        final dashboard = controller.dashboard.value;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            StoreProfileCard(
              storeName: store.name,
              phone: store.phone,
              imageUrl: store.imageUrl,
              onEditPressed: () => Get.toNamed(
                Routes.createStoreRoute,
                arguments: {'isEdit': true},
              ),
            ),

            SizedBox(height: 24),

            SectionTitle(
              title: 'Menu Utama',
              child: Column(
                children: [
                  MenuCard(
                    icon: Icons.inventory_2_outlined,
                    title: 'Kelola Produk',
                    subtitle: 'Tambahkan & ubah menu.',
                    onTap: () => Get.toNamed(Routes.productManagementRoute),
                  ),

                  SizedBox(height: 12),

                  MenuCard(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Pesanan Masuk',
                    subtitle: 'Proses pesanan baru.',
                    onTap: () => Get.toNamed(Routes.sellerOrderListRoute),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            SectionTitle(
              title: 'Ringkasan Performa',
              child: Obx(() {
                if (controller.isLoadingDashboard.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: PerformaCard.revenue(
                        totalRevenue: dashboard?.totalRevenue ?? 0,
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: PerformaCard.totalOrders(
                        totalOrders: dashboard?.totalOrders ?? 0,
                      ),
                    ),
                  ],
                );
              }),
            ),

            SizedBox(height: 24),

            SectionTitle(
              title: 'Pesanan Terbaru',
              child: Obx(() {
                if (controller.isLoadingDashboard.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final orders = controller.recentOrders;
                if (orders.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Belum ada pesanan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return Column(
                  children: orders.take(5).map((order) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OrderCard.fromOrder(
                        order: order,
                        onTap: () => Get.toNamed(
                          Routes.sellerOrderListRoute,
                          arguments: {'orderId': order.id},
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
