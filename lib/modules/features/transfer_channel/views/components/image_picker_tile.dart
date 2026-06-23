import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class ImagePickerTile extends StatelessWidget {
  const ImagePickerTile({
    super.key,
    required this.label,
    required this.hint,
    required this.file,
    required this.onTap,
  });

  final String label;
  final String hint;
  final Rx<File?> file;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColor.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.inputBorder),
        ),
        child: Obx(
          () => Row(
            children: [
              file.value != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        file.value!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColor.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.image_outlined,
                        color: AppColor.primary,
                      ),
                    ),

              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyle.bodyMedium),

                    SizedBox(height: 2),

                    Text(
                      file.value != null
                          ? file.value!.path.split('/').last
                          : hint,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.textHint,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, color: AppColor.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
