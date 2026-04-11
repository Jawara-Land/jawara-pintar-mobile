import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/profile/controllers/profile_controller.dart';
import 'package:jawara_mobile/shared/controllers/auth_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColor.background,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            children: [
              Center(
                child: Obx(() {
                  final user = AuthController.to.currentUser.value;
                  final name = user?.name ?? 'User';
                  final email = user?.email ?? '-';
                  final roles = user?.roles ?? [];
                  final roleLabel = roles.isNotEmpty
                      ? roles.map((r) => _formatRole(r)).join(', ')
                      : '-';

                  return Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.primaryLight,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: AppColor.primary,
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        name,
                        style: AppTextStyle.headingSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        email,
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.textTertiary,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Role : $roleLabel',
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.textTertiary,
                        ),
                      ),
                    ],
                  );
                }),
              ),

              SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSection(
                  title: 'Pengaturan Akun',
                  items: [
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      label: 'Ubah Profil',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.lock_outline,
                      label: 'Ubah Kata Sandi',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSection(
                  title: 'Umum',
                  items: [
                    _buildMenuItem(
                      icon: Icons.notifications_none,
                      label: 'Notifikasi',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      label: 'Bantuan',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      label: 'Tentang Aplikasi',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSection(
                  title: 'Aktifitas',
                  items: [
                    _buildMenuItem(
                      icon: Icons.logout,
                      label: 'Keluar',
                      onTap: () {
                        _showLogoutConfirmation();
                      },
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Keluar'),
        content: Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal')),

          TextButton(
            onPressed: () {
              Get.back();
              AuthController.to.logout();
            },
            style: TextButton.styleFrom(foregroundColor: AppColor.error),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  String _formatRole(String role) {
    switch (role) {
      case 'resident':
        return 'Warga';
      case 'community_head':
        return 'Ketua RT/RW';
      case 'admin':
        return 'Admin';
      default:
        return role;
    }
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(title, style: AppTextStyle.titleLarge),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColor.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isLogout ? AppColor.error : AppColor.textSecondary,
            ),

            SizedBox(width: 12),

            Expanded(
              child: Text(
                label,
                style: AppTextStyle.titleMedium.copyWith(
                  color: isLogout ? AppColor.error : AppColor.textSecondary,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right,
              size: 22,
              color: isLogout ? AppColor.error : AppColor.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
