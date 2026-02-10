import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/shared/styles/app_color.dart';

class AppTextStyle {
  AppTextStyle._(); 

  static TextStyle get displayLarge => GoogleFonts.figtree(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColor.textPrimary,
    height: 1.2,
  );

  static TextStyle get displayMedium => GoogleFonts.figtree(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColor.textPrimary,
    height: 1.2,
  );

  static TextStyle get displaySmall => GoogleFonts.figtree(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimary,
    height: 1.2,
  );

  static TextStyle get headingLarge => GoogleFonts.figtree(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColor.textPrimary,
  );

  static TextStyle get headingMedium => GoogleFonts.figtree(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimary,
  );

  static TextStyle get headingSmall => GoogleFonts.figtree(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimary,
  );

  static TextStyle get titleLarge => GoogleFonts.figtree(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColor.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.figtree(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColor.textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.figtree(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.figtree(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.figtree(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColor.textSecondary,
  );

  static TextStyle get labelLarge => GoogleFonts.figtree(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColor.textSecondary,
  );

  static TextStyle get labelMedium => GoogleFonts.figtree(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColor.textSecondary,
  );

  static TextStyle get labelSmall => GoogleFonts.figtree(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColor.textSecondary,
  );

  static TextStyle get caption => GoogleFonts.figtree(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColor.textTertiary,
  );

  static TextStyle get analyticsValue => GoogleFonts.figtree(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    color: AppColor.textSecondary,
    height: 1.0,
  );

  static TextStyle get inputHint => GoogleFonts.figtree(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.textHint,
  );

  static TextStyle get inputHintSmall => GoogleFonts.figtree(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColor.textHint,
  );
}
