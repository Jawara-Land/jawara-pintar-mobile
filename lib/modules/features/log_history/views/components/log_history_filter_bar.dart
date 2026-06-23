import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import '../../controllers/log_history_controller.dart';

class LogHistoryFilterBar extends StatelessWidget {
  const LogHistoryFilterBar({super.key, required this.controller});

  final LogHistoryController controller;

  Future<void> _showDateRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColor.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      String fmt(DateTime d) =>
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      controller.applyDateRange(from: fmt(picked.start), to: fmt(picked.end));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          TextFormField(
            onChanged: controller.applyDescriptionFilter,
            decoration: InputDecoration(
              hintText: 'Cari deskripsi aktivitas...',
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

          SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDateRangePicker(context),
                  icon: const Icon(
                    Icons.date_range_outlined,
                    size: 16,
                    color: AppColor.primary,
                  ),
                  label: Obx(
                    () => Text(
                      controller.filterFrom.value.isEmpty
                          ? 'Filter Tanggal'
                          : '${controller.filterFrom.value} – ${controller.filterTo.value}',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColor.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 8),

              Obx(
                () =>
                    controller.filterFrom.value.isNotEmpty ||
                        controller.searchDescription.value.isNotEmpty
                    ? IconButton(
                        onPressed: controller.clearFilters,
                        icon: const Icon(
                          Icons.clear,
                          color: AppColor.error,
                          size: 20,
                        ),
                        tooltip: 'Hapus Filter',
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
