import 'package:flutter/material.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import '../../models/activity_log_model.dart';

class ActivityLogCard extends StatelessWidget {
  const ActivityLogCard({super.key, required this.log});

  final ActivityLog log;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.border),
        boxShadow: const [
          BoxShadow(
            color: AppColor.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.history_edu_outlined,
                color: AppColor.primary,
                size: 20,
              ),
            ),
            
            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.description,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColor.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  SizedBox(height: 4),

                  if (log.causer != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 13,
                          color: AppColor.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          log.causer!,
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  
                  SizedBox(height: 4),

                  if (log.createdAt != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 13,
                          color: AppColor.textHint,
                        ),
                        
                        SizedBox(width: 4),
                        
                        Text(
                          log.createdAt!,
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.textHint,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
