import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  // Primary
  static const Color primary = Color(0xFF635BFF);
  static const Color primaryLight = Color(0xFFE6ECFF);
  static const Color primarySurface = Color(0xFFE6E4E4);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Neutral / Surface
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F0EF);
  static const Color notificationUnread = Color(0xFF2196F3);
  static const Color backgroundAlt = Color(0xFFE3F2FD);
  static const Color overlay = Color(0x99000000); // 60% opacity black
  static const Color transparent = Color(0x00000000);

  // Border / Divider
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE6E4E4);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF374151);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic / Status
  static const Color success = Color(0xFF22C55E);
  static const Color successDark = Color(0xFF16A34A);
  static const Color warning = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);

  // Order Status
  static const Color statusPending = Color(0xFFF97316);
  static const Color statusPaid = Color(0xFF3B82F6);
  static const Color statusProcessed = Color(0xFF8B5CF6);
  static const Color statusShipped = Color(0xFF6366F1);

  // Shadows
  static const Color shadow = Color(0x14000000);
  static const Color shadowDark = Color(0x36000000);
  static const Color shadowLight = Color(0x0D000000);

  // Input Field
  static const Color inputFill = Color(0xFFFAFAFA);
  static const Color inputFillDisabled = Color(0xFFEEEEEE);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputIcon = Color(0xFF757575);
}
