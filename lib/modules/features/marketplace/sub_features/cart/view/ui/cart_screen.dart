import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/cart/controllers/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
        actions: [
          Obx(() {
            final isAllSelected =
                controller.cartItems.isNotEmpty &&
                controller.selectedCartItemIds.length ==
                    controller.cartItems.length;

            return TextButton(
              onPressed: () => controller.toggleAllSelections(!isAllSelected),
              child: Text(
                isAllSelected ? 'Unselect All' : 'Select All',
                style: AppTextStyle.labelLarge.copyWith(
                  color: AppColor.textOnPrimary,
                ),
              ),
            );
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchCart,
        child: Obx(() {
          if (controller.isLoading.value && controller.cartItems.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.cartItems.isEmpty) {
            return AppEmptyState(
              icon: Icons.shopping_cart_outlined,
              message: 'Keranjang kosong',
            );
          }

          final groupedItems = controller.itemsGroupedByStore;
          final storeIds = groupedItems.keys.toList();

          return ListView.builder(
            itemCount: storeIds.length,
            itemBuilder: (context, storeIndex) {
              final storeId = storeIds[storeIndex];
              final storeItems = groupedItems[storeId]!;
              final storeName = controller.getStoreName(storeId);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Container(
                      color: AppColor.background,
                      child: CheckboxListTile(
                        value: controller.isStoreFullySelected(storeId),
                        onChanged: (val) =>
                            controller.toggleStoreSelection(storeId),
                        title: Row(
                          children: [
                            Icon(
                              Icons.store,
                              size: 18,
                              color: AppColor.primary,
                            ),

                            SizedBox(width: 8),

                            Text(storeName, style: AppTextStyle.titleMedium),
                          ],
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),

                  ...storeItems.map((item) => _buildCartItem(item)),
                  if (storeIndex < storeIds.length - 1) Divider(thickness: 4),
                ],
              );
            },
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.surface,
            boxShadow: [
              BoxShadow(
                color: AppColor.shadow,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Belanja',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColor.textTertiary,
                    ),
                  ),

                  Obx(
                    () => CurrencyText(
                      controller.selectedTotalAmount,
                      style: AppTextStyle.headingSmall,
                    ),
                  ),
                ],
              ),
              
              ElevatedButton(
                onPressed: controller.proceedToCheckout,
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(dynamic item) {
    final product = item.product;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.selectedCartItemIds.contains(item.id),
                onChanged: (val) {
                  controller.toggleItemSelection(item.id);
                },
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => Get.toNamed(
                  Routes.productDetailRoute,
                  arguments: {'id': product.id},
                ),
                child: Row(
                  children: [
                    if (product.imageUrl != null)
                      CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(
                        width: 60,
                        height: 60,
                        color: AppColor.surfaceVariant,
                      ),

                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: AppTextStyle.titleMedium),
                          CurrencyText(
                            product.price,
                            style: AppTextStyle.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline, size: 20),
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(4),
                      onPressed: () =>
                          controller.updateQuantity(item.id, item.quantity - 1),
                    ),
                    Obx(() {
                      final currentItem = controller.cartItems.firstWhereOrNull(
                        (e) => e.id == item.id,
                      );
                      return Text('${currentItem?.quantity ?? item.quantity}');
                    }),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, size: 20),
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(4),
                      onPressed: () =>
                          controller.updateQuantity(item.id, item.quantity + 1),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColor.error, size: 20),
                  onPressed: () => controller.removeItem(item.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
