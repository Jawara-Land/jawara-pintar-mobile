import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/controllers/address_controller.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class AddressListScreen extends GetView<AddressController> {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alamat Pengiriman')),
      body: Obx(() {
        if (controller.isLoading.value && controller.addresses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.addresses.isEmpty) {
          return AppEmptyState(
            icon: Icons.location_on_outlined,
            message: 'Belum ada alamat disimpan',
            actionLabel: 'Tambah Alamat',
            onAction: () => Get.toNamed(Routes.addressFormRoute),
          );
        }

        return ListView.builder(
          itemCount: controller.addresses.length,
          itemBuilder: (context, index) {
            final address = controller.addresses[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      address.label ?? 'Alamat',
                      style: AppTextStyle.titleMedium,
                    ),

                    if (address.isPrimary) ...[
                      SizedBox(width: 8),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.success,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Utama',
                          style: AppTextStyle.caption.copyWith(
                            color: AppColor.textOnPrimary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),

                    Text(address.address),
                    
                    if (address.phone != null) ...[
                      const SizedBox(height: 4),
                      Text('No. HP: ${address.phone}'),
                    ],
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'edit') {
                      controller.populateForm(address);
                      Get.toNamed(
                        '${Routes.marketplaceRoute}/addresses/form',
                        arguments: {'id': address.id},
                      );
                    } else if (val == 'delete') {
                      controller.deleteAddress(address.id);
                    } else if (val == 'primary') {
                      controller.setPrimary(address.id);
                    }
                  },
                  itemBuilder: (context) => [
                    if (!address.isPrimary)
                      const PopupMenuItem(
                        value: 'primary',
                        child: Text('Set Utama'),
                      ),
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
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
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearForm();
          Get.toNamed('${Routes.marketplaceRoute}/addresses/form');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
