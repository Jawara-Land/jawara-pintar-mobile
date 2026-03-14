import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class AspirationScreen extends StatelessWidget {
  const AspirationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'Pesan Warga',
          style: AppTextStyle.headingSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColor.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _buildAspirationCard(
            title: 'Lampu Jalan Mati',
            author: 'Pak Budi',
            status: 'Menunggu',
            statusColor: AppColor.warning,
            statusTextColor: AppColor.textPrimary,
            date: '25 Desember 2026',
          ),

          SizedBox(height: 12),

          _buildAspirationCard(
            title: 'Got Tersumbat',
            author: 'Bu Andin',
            status: 'Menunggu',
            statusColor: AppColor.warning,
            statusTextColor: AppColor.textPrimary,
            date: '13 November 2026',
          ),

          SizedBox(height: 12),

          _buildAspirationCard(
            title: 'Jalan Ambles',
            author: 'Pak Ali',
            status: 'Diterima',
            statusColor: AppColor.success,
            statusTextColor: AppColor.textOnPrimary,
            date: '09 November 2026',
          ),
        ],
      ),
    );
  }

  Widget _buildAspirationCard({
    required String title,
    required String author,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: AppTextStyle.titleLarge)),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, size: 20, color: AppColor.textSecondary),
              const SizedBox(width: 8),
              Text(author, style: AppTextStyle.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.schedule,
                size: 20,
                color: AppColor.textSecondary,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: AppTextStyle.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusTextColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          Text(date, style: AppTextStyle.bodySmall),
        ],
      ),
    );
  }
}
