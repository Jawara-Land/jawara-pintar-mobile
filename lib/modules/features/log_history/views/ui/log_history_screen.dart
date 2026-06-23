import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_empty_state.dart';
import '../../controllers/log_history_controller.dart';
import '../components/activity_log_card.dart';
import '../components/log_history_filter_bar.dart';

class LogHistoryScreen extends GetView<LogHistoryController> {
  const LogHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        title: Text('Riwayat Aktivitas', style: AppTextStyle.headingSmall),
        centerTitle: false,
      ),
      body: Column(
        children: [
          LogHistoryFilterBar(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.logs.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.primary),
                );
              }

              if (controller.errorMessage.isNotEmpty &&
                  controller.logs.isEmpty) {
                return AppEmptyState(
                  icon: Icons.error_outline,
                  message: controller.errorMessage.value,
                  actionLabel: 'Coba Lagi',
                  onAction: controller.fetchLogs,
                );
              }

              if (controller.logs.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.history_outlined,
                  message: 'Belum ada riwayat aktivitas.',
                );
              }

              return RefreshIndicator(
                color: AppColor.primary,
                onRefresh: controller.fetchLogs,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: controller.logs.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 8),
                  itemBuilder: (_, index) =>
                      ActivityLogCard(log: controller.logs[index]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
