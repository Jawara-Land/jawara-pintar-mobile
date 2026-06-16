import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class StoreProfileCard extends StatelessWidget {
  final String storeName;
  final String? phone;
  final String? imageUrl;
  final VoidCallback? onEditPressed;

  const StoreProfileCard({
    super.key,
    required this.storeName,
    this.phone,
    this.imageUrl,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: AppColor.surface,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        imageUrl!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.store, size: 35),
                      ),
                    )
                  : const Icon(Icons.store, size: 35, color: AppColor.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeName,
                    style: AppTextStyle.headingMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 16,
                        color: AppColor.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        phone ?? 'Belum ada nomor telepon',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onEditPressed != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: onEditPressed,
              ),
          ],
        ),
      ),
    );
  }
}
