import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/home/view/components/home_analytics_section.dart';
import 'package:jawara_mobile/modules/features/home/view/components/home_header.dart';
import 'package:jawara_mobile/modules/features/home/view/components/home_quick_actions_section.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
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

              HomeQuickActionsSection(
                actions: [
                  HomeQuickAction(
                    icon: Icons.grid_view,
                    label: 'Dasbor',
                    onTap: () => Get.toNamed(Routes.mainRoute),
                  ),
                  HomeQuickAction(icon: Icons.people, label: 'Data Warga'),
                  HomeQuickAction(
                    icon: Icons.account_balance_wallet,
                    label: 'Pemasukan',
                  ),
                  HomeQuickAction(icon: Icons.payments, label: 'Pengeluaran'),
                  HomeQuickAction(icon: Icons.description, label: 'Laporan'),
                  HomeQuickAction(
                    icon: Icons.calendar_month,
                    label: 'Kegiatan',
                    onTap: () {},
                  ),
                  HomeQuickAction(
                    icon: Icons.campaign,
                    label: 'Pengumuman',
                    onTap: () {},
                  ),
                  HomeQuickAction(
                    icon: Icons.store,
                    label: 'Pasar Lokal',
                    onTap: () {
                      Get.toNamed(Routes.marketplaceRoute);
                    },
                  ),
                  HomeQuickAction(
                    icon: Icons.message,
                    label: 'Pesan Warga',
                    onTap: () {},
                  ),
                  HomeQuickAction(
                    icon: Icons.manage_accounts,
                    label: 'Kelola Pengguna',
                    onTap: () {},
                  ),
                  HomeQuickAction(
                    icon: Icons.history,
                    label: 'Riwayat Aktivitas',
                    onTap: () {},
                  ),
                  HomeQuickAction(
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
  }
}
