import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/controllers/order_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/controllers/address_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/cart/models/cart_item_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/models/address_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/models/marketplace_setting_model.dart';
import 'package:jawara_mobile/modules/features/marketplace/repositories/marketplace_repository.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final orderController = Get.find<OrderController>();
  final addressController = Get.put(AddressController());

  late final List<CartItemModel> selectedItems;

  String deliveryMethod = 'pickup';
  AddressModel? selectedAddress;
  final notesController = TextEditingController();
  MarketplaceSettingModel? _settings;
  bool _loadingSettings = true;

  @override
  void initState() {
    super.initState();
    selectedItems = Get.arguments?['selected_items'] ?? [];
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    try {
      final response = await MarketplaceRepository.getSettings();
      if (response['success'] == true) {
        setState(() {
          _settings = MarketplaceSettingModel.fromJson(
            response['data']['settings'] ?? {},
          );
        });
      }
    } catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
    } finally {
      setState(() => _loadingSettings = false);
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  int get itemsSubtotal {
    return selectedItems.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  int get calculatedShippingCost {
    if (deliveryMethod != 'delivery') return 0;
    final uniqueStoreIds = selectedItems
        .map((item) => item.product.storeId)
        .toSet();
    int totalShipping = 0;
    for (var storeId in uniqueStoreIds) {
      final item = selectedItems.firstWhere(
        (e) => e.product.storeId == storeId,
      );
      final num? storeShipping = item.product.store?.shippingCost;
      final num? defaultShipping = item.product.storeDefaultShipping;
      totalShipping += (storeShipping ?? defaultShipping ?? 0).toInt();
    }
    return totalShipping;
  }

  int get calculatedServiceFee {
    if (_settings == null) return 0;
    if (_settings!.serviceFeeType == 'percentage') {
      return (itemsSubtotal * _settings!.serviceFeeAmount / 100).round();
    }
    return _settings!.serviceFeeAmount.toInt();
  }

  int get grandTotal =>
      itemsSubtotal + calculatedShippingCost + calculatedServiceFee;

  Map<int, List<CartItemModel>> get itemsByStore {
    final map = <int, List<CartItemModel>>{};
    for (final item in selectedItems) {
      map.putIfAbsent(item.product.storeId, () => []).add(item);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    if (selectedItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const AppEmptyState(
          message: 'Tidak ada item yang dipilih untuk checkout',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ringkasan Pesanan', style: AppTextStyle.headingSmall),

            SizedBox(height: 8),

            ...itemsByStore.entries.map((entry) {
              final storeItems = entry.value;
              final storeName = storeItems.first.product.storeName ?? 'Toko';
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store header
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.background,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.store, size: 16, color: AppColor.primary),

                          SizedBox(width: 8),

                          Text(storeName, style: AppTextStyle.titleMedium),
                        ],
                      ),
                    ),

                    Divider(height: 1),

                    // Items
                    ...storeItems.map(
                      (item) => ListTile(
                        leading: item.product.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: CachedNetworkImage(
                                  imageUrl: item.product.imageUrl!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: 40,
                                height: 40,
                                color: AppColor.surfaceVariant,
                                child: const Icon(Icons.image, size: 20),
                              ),
                        title: Text(
                          item.product.name,
                          style: AppTextStyle.bodyMedium,
                        ),
                        subtitle: Text(
                          '${item.quantity}x  ${formatRupiah(item.product.price)}',
                        ),
                        trailing: CurrencyText(
                          item.product.price * item.quantity,
                          style: AppTextStyle.titleMedium,
                        ),
                        dense: true,
                      ),
                    ),
                  ],
                ),
              );
            }),

            Divider(height: 32),

            Text('Metode Pengiriman', style: AppTextStyle.titleLarge),

            RadioListTile(
              title: const Text('Ambil Sendiri (Pickup)'),
              value: 'pickup',
              groupValue: deliveryMethod,
              onChanged: (val) =>
                  setState(() => deliveryMethod = val.toString()),
            ),

            RadioListTile(
              title: const Text('Kirim ke Alamat (Delivery)'),
              value: 'delivery',
              groupValue: deliveryMethod,
              onChanged: (val) =>
                  setState(() => deliveryMethod = val.toString()),
            ),

            if (deliveryMethod == 'delivery') ...[
              SizedBox(height: 12),
              Text('Alamat Pengiriman *', style: AppTextStyle.labelLarge),

              SizedBox(height: 8),

              Obx(() {
                if (addressController.isLoading.value) {
                  return const CircularProgressIndicator();
                }

                if (addressController.addresses.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anda belum memiliki alamat pengiriman.',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.error,
                        ),
                      ),

                      SizedBox(height: 8),

                      ElevatedButton.icon(
                        onPressed: () => Get.toNamed(Routes.addressFormRoute),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Alamat Baru'),
                      ),
                    ],
                  );
                }

                selectedAddress ??=
                    addressController.addresses.firstWhereOrNull(
                      (e) => e.isPrimary,
                    ) ??
                    addressController.addresses.first;

                return Column(
                  children: [
                    DropdownButtonFormField<AddressModel>(
                      initialValue: selectedAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: addressController.addresses.map((addr) {
                        final labelStr = addr.label != null
                            ? '[${addr.label}] '
                            : '';
                        return DropdownMenuItem<AddressModel>(
                          value: addr,
                          child: Text(
                            '$labelStr${addr.address}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedAddress = val;
                        });
                      },
                    ),

                    SizedBox(height: 8),

                    TextButton.icon(
                      onPressed: () => Get.toNamed(Routes.addressListRoute),
                      icon: const Icon(Icons.edit_location_alt),
                      label: const Text('Kelola Alamat Pengiriman'),
                    ),
                  ],
                );
              }),
            ],

            Divider(height: 32),

            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Catatan untuk penjual (Opsional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

            Divider(height: 32),

            // Price breakdown
            PriceRow(label: 'Subtotal Produk', amount: itemsSubtotal),

            SizedBox(height: 4),

            PriceRow(label: 'Ongkos Kirim', amount: calculatedShippingCost),

            SizedBox(height: 4),

            PriceRow(
              label:
                  'Biaya Layanan${_settings != null && _settings!.serviceFeeType == 'percentage' ? ' (${_settings!.serviceFeeAmount}%)' : ''}',
              amount: calculatedServiceFee,
            ),

            Divider(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Pembayaran:', style: AppTextStyle.titleLarge),

                CurrencyText(
                  grandTotal,
                  style: AppTextStyle.headingSmall.copyWith(
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (deliveryMethod == 'delivery' && selectedAddress == null) {
                    Get.snackbar('Error', 'Silakan tentukan alamat pengiriman');
                    return;
                  }

                  orderController.processCheckout(
                    deliveryMethod: deliveryMethod,
                    cartItemIds: selectedItems.map((e) => e.id).toList(),
                    addressId: deliveryMethod == 'delivery'
                        ? selectedAddress?.id
                        : null,
                    notes: notesController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Buat Pesanan & Bayar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
