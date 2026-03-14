import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'Pengumuman',
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
          _buildAnnouncementCard(
            date: '12 Oktober 2026',
            title: 'Bersih Desa',
            category: 'Kebersihan & Keamanan',
            organizer: 'Pak Budi',
          ),
          const SizedBox(height: 12),
          _buildAnnouncementCard(
            date: '29 November 2026',
            title: 'Tahil Akbar',
            category: 'Keagamaan',
            organizer: 'Ormas Masjid',
          ),
          const SizedBox(height: 12),
          _buildAnnouncementCard(
            date: '10 Desember 2026',
            title: 'Musyawarah',
            category: 'Komunitas & Sosial',
            organizer: 'Pak RW',
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard({
    required String date,
    required String title,
    required String category,
    required String organizer,
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
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColor.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(date, style: AppTextStyle.bodySmall),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          SizedBox(height: 8),

          Text(title, style: AppTextStyle.titleLarge),

          SizedBox(height: 12),

          Row(
            children: [
              Icon(Icons.groups, size: 20, color: AppColor.textSecondary),

              SizedBox(width: 8),

              Expanded(child: Text(category, style: AppTextStyle.bodySmall)),
            ],
          ),

          SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.person, size: 20, color: AppColor.textSecondary),

              SizedBox(width: 8),

              Expanded(child: Text(organizer, style: AppTextStyle.bodySmall)),
            ],
          ),
        ],
      ),
    );
  }
}