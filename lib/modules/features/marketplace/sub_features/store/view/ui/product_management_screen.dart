import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/controllers/store_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class ProductManagementScreen extends GetView<StoreController> {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kelola Produk')),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryLight,
        onPressed: () => Get.toNamed(
          Routes.productFormRoute,
        )?.then((_) => controller.fetchMyProducts()),
        child: Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchField(
                    hintText: 'Cari produk...',
                    onChanged: controller.setSearchQuery,
                    padding: EdgeInsets.zero,
                  ),
                ),

                SizedBox(width: 8),

                Obx(
                  () => PopupMenuButton<String>(
                    icon: Icon(Icons.filter_list, color: AppColor.primary),
                    initialValue: controller.selectedFilter.value,
                    onSelected: (value) => controller.setFilter(value),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'all', child: Text('Semua Produk')),

                      PopupMenuItem(
                        value: 'active',
                        child: Text('Hanya Aktif'),
                      ),

                      PopupMenuItem(
                        value: 'inactive',
                        child: Text('Hanya Nonaktif'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 2,
              shadowColor: AppColor.shadowDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Produk', style: AppTextStyle.titleMedium),

                    Obx(
                      () => Text(
                        '${controller.myProducts.length}',
                        style: AppTextStyle.titleLarge.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      height: 30.0,
                      width: 1.5,
                      color: AppColor.primaryLight,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                    ),

                    Text('Aktif', style: AppTextStyle.titleMedium),

                    Obx(
                      () => Text(
                        '${controller.filteredProducts.where((p) => p.isActive).length}',
                        style: AppTextStyle.titleLarge.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 8),

          Expanded(
            child: Obx(() {
              if (controller.isLoadingProducts.value &&
                  controller.myProducts.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.myProducts.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.inventory_outlined,
                  message: 'Toko Anda belum memiliki produk.',
                );
              }

              if (controller.filteredProducts.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.search_off,
                  message: 'Tidak ada produk yang cocok dengan pencarian.',
                );
              }

              return ListView.builder(
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];

                  return Card(
                    elevation: 3,
                    shadowColor: AppColor.shadowDark,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      leading: product.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: product.imageUrl!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColor.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                      title: Text(
                        product.name,
                        style: AppTextStyle.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Row(
                            children: [
                              CurrencyText(
                                product.price,
                                style: AppTextStyle.bodyMedium.copyWith(
                                  color: AppColor.primary,
                                ),
                              ),
                              Container(
                                height: 10.0,
                                width: 1.0,
                                color: AppColor.shadowDark,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                              ),
                              Text(
                                'Stok: ${product.stock}',
                                style: AppTextStyle.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: product.isActive,
                            onChanged: (value) =>
                                controller.toggleProductStatus(product, value),
                            activeTrackColor: AppColor.successDark,
                            activeThumbColor: AppColor.surface,
                          ),
                          PopupMenuButton<String>(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text(
                                  'Hapus',
                                  style: AppTextStyle.bodyMedium.copyWith(
                                    color: AppColor.error,
                                  ),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                Get.toNamed(
                                  Routes.productFormRoute,
                                  arguments: {'product': product},
                                )?.then((_) => controller.fetchMyProducts());
                              } else if (value == 'delete') {
                                Get.defaultDialog(
                                  title: 'Konfirmasi',
                                  middleText:
                                      'Yakin ingin menghapus produk ini?',
                                  textConfirm: 'Hapus',
                                  textCancel: 'Batal',
                                  confirmTextColor: AppColor.textOnPrimary,
                                  onConfirm: () {
                                    Get.back();
                                    controller.deleteProduct(product.id);
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
