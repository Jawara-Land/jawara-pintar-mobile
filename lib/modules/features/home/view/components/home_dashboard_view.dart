import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/home/view/components/home_analytics_section.dart';
import 'package:jawara_mobile/modules/features/home/view/components/home_header.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      final user = authController.currentUser.value;
      final permissions = user?.permissions;
      final hasDataAccess =
          permissions != null &&
          (permissions.hasDataAccess || permissions.myFamily);

      return Container(
        color: AppColor.background,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(),

                SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Ringkasan Analitik',
                    style: AppTextStyle.titleLarge.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                HomeAnalyticsSection(),

                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Menu Cepat',
                    style: AppTextStyle.titleLarge.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                QuickActionGrid(
                  items: [
                    QuickActionItem(
                      icon: Icons.grid_view_rounded,
                      label: 'Dasbor',
                      onTap: () => Get.toNamed(Routes.mainRoute),
                    ),
                    if (hasDataAccess)
                      QuickActionItem(
                        icon: Icons.people,
                        label: 'Data Warga',
                        onTap: () => Get.toNamed(Routes.dataRoute),
                      ),
                    QuickActionItem(
                      icon: Icons.account_balance_wallet,
                      label: 'Pemasukan',
                      onTap: () => Get.toNamed(Routes.incomeRoute),
                    ),
                    QuickActionItem(
                      icon: Icons.payments,
                      label: 'Pengeluaran',
                      onTap: () => Get.toNamed(Routes.expenseRoute),
                    ),
                    QuickActionItem(icon: Icons.description, label: 'Laporan'),
                    QuickActionItem(
                      icon: Icons.calendar_month,
                      label: 'Kegiatan',
                      onTap: () {},
                    ),
                    QuickActionItem(
                      icon: Icons.campaign,
                      label: 'Pengumuman',
                      onTap: () {},
                    ),

                    if (!user!.roles.any(
                      (r) => [
                        'treasurer',
                        'secretary',
                        'neighborhood_head',
                      ].contains(r),
                    ))
                      QuickActionItem(
                        icon: Icons.store,
                        label: 'Pasar Lokal',
                        onTap: () {
                          Get.toNamed(Routes.marketplaceRoute);
                        },
                      ),

                    QuickActionItem(
                      icon: Icons.message,
                      label: 'Pesan Warga',
                      onTap: () {},
                    ),
                    QuickActionItem(
                      icon: Icons.manage_accounts,
                      label: 'Pengguna & Pengajuan Warga',
                      onTap: () {
                        Get.toNamed(Routes.userManagementRoute);
                      },
                    ),
                    QuickActionItem(
                      icon: Icons.history,
                      label: 'Riwayat Aktivitas',
                      onTap: () {
                        Get.toNamed(Routes.logHistoryRoute);
                      },
                    ),
                    QuickActionItem(
                      icon: Icons.account_balance,
                      label: 'Channel Transfer',
                      onTap: () {
                        Get.toNamed(Routes.transferChannelRoute);
                      },
                    ),
                    QuickActionItem(
                      icon: Icons.more_horiz,
                      label: 'Lainnya',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
