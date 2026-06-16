import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/marketplace/controllers/product_detail_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/cart/controllers/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class ProductDetailScreen extends GetView<ProductDetailController> {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk'), actions: [
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = controller.product.value;
        if (product == null) {
          return const Center(child: Text('Produk tidak ditemukan'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (product.imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: product.imageUrl!,
                      height: 320,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      height: 320,
                      width: double.infinity,
                      color: AppColor.surfaceVariant,
                    ),

                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 280.0, 16.0, 16.0),
                    padding: EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppTextStyle.headingLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        CurrencyText(
                          product.price,
                          style: AppTextStyle.headingMedium.copyWith(
                            color: AppColor.primary,
                          ),
                        ),

                        SizedBox(height: 16),

                        Row(
                          children: [
                            if ((product.storeImageUrl != null &&
                                    product.storeImageUrl!.isNotEmpty) ||
                                (product.store?.imageUrl != null &&
                                    product.store!.imageUrl!.isNotEmpty))
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      (product.storeImageUrl != null &&
                                          product.storeImageUrl!.isNotEmpty)
                                      ? product.storeImageUrl!
                                      : product.store!.imageUrl!,
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                        radius: 16,
                                        child: Icon(Icons.store, size: 16),
                                      ),
                                ),
                              )
                            else
                              const CircleAvatar(
                                radius: 16,
                                child: Icon(Icons.store, size: 16),
                              ),

                            SizedBox(width: 8),

                            Text(
                              product.storeName ?? 'Toko Tidak Diketahui',
                              style: AppTextStyle.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  bottom: 32.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi',
                      style: AppTextStyle.headingSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      product.description ?? 'Tidak ada deskripsi',
                      style: AppTextStyle.bodyMedium,
                    ),

                    SizedBox(height: 24),

                    Text(
                      'Informasi Tambahan',
                      style: AppTextStyle.headingSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 20,
                                ),

                                SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    'Stok: ${product.stock}',
                                    style: AppTextStyle.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 12),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.category_outlined, size: 20),

                                SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    'Kategori: ${product.categoryName ?? '-'}',
                                    style: AppTextStyle.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (product.type == 'goods' && product.weight != null) ...[
                      SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.scale_outlined, size: 20),
                            SizedBox(width: 8),

                            Text(
                              'Berat: ${product.weight} gram',
                              style: AppTextStyle.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Show service-specific info for services
                    if (product.type == 'service') ...[
                      SizedBox(height: 12),

                      if (product.duration != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColor.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.schedule_outlined, size: 20),

                              SizedBox(width: 8),

                              Text(
                                'Durasi: ${product.duration}',
                                style: AppTextStyle.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      if (product.location != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColor.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 20),

                              SizedBox(width: 8),

                              Text(
                                'Lokasi: ${product.location}',
                                style: AppTextStyle.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      if (product.tnc != null) ...[
                        Text(
                          'Syarat & Ketentuan:',
                          style: AppTextStyle.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(product.tnc!, style: AppTextStyle.bodyMedium),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => Get.toNamed(Routes.cartRoute),
                  icon: Obx(() {
                    final count = cartController.cartItems.length;
                    return Badge(
                      isLabelVisible: count > 0,
                      label: Text('$count'),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColor.primary,
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(width: 8),

              Expanded(
                child: Obx(
                  () => ElevatedButton(
                    onPressed: cartController.isAddingToCart.value
                        ? null
                        : () {
                            if (controller.product.value?.stock == 0) {
                              Get.snackbar('Info', 'Stok habis');
                              return;
                            }
                            controller.addToCart(1);
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: cartController.isAddingToCart.value
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColor.textOnPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Tambah ke Keranjang'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
