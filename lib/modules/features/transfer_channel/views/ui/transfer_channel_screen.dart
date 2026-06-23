import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_empty_state.dart';
import '../../controllers/transfer_channel_controller.dart';
import '../components/transfer_channel_card.dart';

class TransferChannelScreen extends GetView<TransferChannelController> {
  const TransferChannelScreen({super.key});

  static const _writeRoles = ['admin', 'community_head', 'treasurer'];

  bool get _canWrite {
    final roles = Get.find<AuthController>().currentUser.value?.roles ?? [];
    return roles.any((r) => _writeRoles.contains(r));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        title: Text('Transfer Channel', style: AppTextStyle.headingSmall),
        centerTitle: false,
      ),
      floatingActionButton: _canWrite
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(Routes.transferChannelCreateRoute),
              backgroundColor: AppColor.primary,
              icon: const Icon(Icons.add, color: AppColor.onPrimary),
              label: Text(
                'Tambah',
                style: AppTextStyle.labelLarge.copyWith(
                  color: AppColor.onPrimary,
                ),
              ),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextFormField(
              onChanged: (val) => controller.fetchChannels(name: val.trim()),
              decoration: InputDecoration(
                hintText: 'Cari channel...',
                hintStyle: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.textHint,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColor.textTertiary,
                ),
                filled: true,
                fillColor: AppColor.inputFill,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColor.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.channels.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.primary),
                );
              }

              if (controller.errorMessage.isNotEmpty &&
                  controller.channels.isEmpty) {
                return AppEmptyState(
                  icon: Icons.error_outline,
                  message: controller.errorMessage.value,
                  actionLabel: 'Coba Lagi',
                  onAction: controller.fetchChannels,
                );
              }

              if (controller.channels.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.account_balance_wallet_outlined,
                  message: 'Belum ada transfer channel.',
                );
              }

              return RefreshIndicator(
                color: AppColor.primary,
                onRefresh: controller.fetchChannels,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: controller.channels.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 8),
                  itemBuilder: (_, index) => TransferChannelCard(
                    channel: controller.channels[index],
                    canWrite: _canWrite,
                    onEdit: () => Get.toNamed(
                      Routes.transferChannelEditRoute,
                      arguments: controller.channels[index],
                    ),
                    onDelete: () => _confirmDelete(
                      context,
                      controller.channels[index].id,
                      controller.channels[index].name,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus Channel', style: AppTextStyle.titleLarge),
        content: Text(
          'Yakin ingin menghapus "$name"?',
          style: AppTextStyle.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: AppTextStyle.labelLarge.copyWith(
                color: AppColor.textTertiary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final ok = await controller.deleteChannel(id);
              if (ok) {
                Get.snackbar(
                  'Berhasil',
                  'Channel berhasil dihapus.',
                  backgroundColor: AppColor.success,
                  colorText: AppColor.onPrimary,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              } else {
                Get.snackbar(
                  'Gagal',
                  controller.errorMessage.value,
                  backgroundColor: AppColor.error,
                  colorText: AppColor.onPrimary,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              }
            },
            child: Text(
              'Hapus',
              style: AppTextStyle.labelLarge.copyWith(color: AppColor.error),
            ),
          ),
        ],
      ),
    );
  }
}
