import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/marketplace/view/components/category_chip.dart';
import 'package:jawara_mobile/modules/features/marketplace/view/components/category_shimmer.dart';
import 'package:jawara_mobile/modules/features/marketplace/view/components/product_card.dart';
import 'package:jawara_mobile/modules/features/marketplace/view/components/product_shimmer_grid.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/marketplace/controllers/marketplace_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/cart/controllers/cart_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/controllers/notification_controller.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class MarketplaceScreen extends GetView<MarketplaceController> {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final notificationController = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Get.back(),
        ),
        title: Text('Marketplace Warga'),
        actions: [
          Obx(
            () => BadgeCount(
              count: cartController.cartItems.length,
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Get.toNamed(Routes.cartRoute),
              ),
            ),
          ),

          Obx(
            () => BadgeCount(
              count: notificationController.unreadCount.value,
              size: 16,
              fontSize: 10,
              child: IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () => Get.toNamed(Routes.notificationListRoute),
              ),
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: Column(
          children: [
            SearchField(
              hintText: 'Cari produk...',
              onChanged: controller.onSearch,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: QuickActionRow(
                items: [
                  QuickActionItem(
                    icon: Icons.list_alt,
                    label: 'Pesanan',
                    onTap: () => Get.toNamed(Routes.orderListRoute),
                  ),
                  QuickActionItem(
                    icon: Icons.history,
                    label: 'Riwayat',
                    onTap: () => Get.toNamed(
                      Routes.orderListRoute,
                      arguments: {'initialTab': 5},
                    ),
                  ),
                  QuickActionItem(
                    icon: Icons.store,
                    label: 'Toko',
                    onTap: () => Get.toNamed(Routes.myStoreRoute),
                  ),
                  QuickActionItem(
                    icon: Icons.location_on_outlined,
                    label: 'Alamat',
                    onTap: () => Get.toNamed(Routes.addressListRoute),
                  ),
                ],
              ),
            ),

            Divider(),

            SizedBox(
              height: 50,
              child: Obx(() {
                if (controller.isLoadingCategories.value) {
                  return CategoryShimmer();
                }
                final selectedId = controller.selectedCategoryId.value;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  itemCount: controller.categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CategoryChip(
                        label: 'Semua',
                        iconName: 'home',
                        isSelected: selectedId == null,
                        onSelected: () => controller.onCategorySelected(null),
                      );
                    }

                    final category = controller.categories[index - 1];

                    return CategoryChip(
                      label: category.name,
                      iconName: category.icon,
                      isSelected: selectedId == category.id,
                      onSelected: () =>
                          controller.onCategorySelected(category.id),
                    );
                  },
                );
              }),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoadingProducts.value &&
                    controller.products.isEmpty) {
                  return ProductShimmerGrid();
                }

                if (controller.products.isEmpty) {
                  return ListView(
                    children: [
                      AppEmptyState(
                        icon: Icons.shopping_bag_outlined,
                        message: 'Tidak ada produk.',
                      ),
                    ],
                  );
                }

                return GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];

                    return ProductCard(product: product);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
