import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography matching nouveauz.com's Google Fonts import:
/// `Playfair+Display:ital,wght@0,400;0,700;0,900;1,400` + `Poppins:wght@300;400;500;600;700`
///
/// Usage convention on the site:
///  - Playfair Display (serif) → headings, product titles, hero title, logo wordmark
///  - Poppins (sans-serif)     → body copy, labels, buttons, nav, prices
class AppTypography {
  AppTypography._();

  static TextStyle playfair({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.text,
    double? letterSpacing,
    double? height,
    FontStyle fontStyle = FontStyle.normal,
  }) =>
      GoogleFonts.playfairDisplay(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        fontStyle: fontStyle,
      );

  static TextStyle poppins({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.text,
    double? letterSpacing,
    double? height,
    FontStyle fontStyle = FontStyle.normal,
  }) =>
      GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        fontStyle: fontStyle,
      );

  // --- Named styles mirrored from the site's inline styles ----------------

  /// `.main-title` — hero headline, gradient-filled on the web (rendered as
  /// a solid brand tone here; see [AppColors.heroGradientStart] family for
  /// the gradient version used by ShaderMask in HeroSection).
  static TextStyle heroTitle(double fontSize) => playfair(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        height: 1.05,
        letterSpacing: -0.5,
      );

  /// `.subtitle` — "INDIAN ETHNIC WEAR, REDEFINED"
  static TextStyle heroSubtitle = poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 4,
    color: AppColors.heroGradientStart,
  );

  /// `.description` — hero paragraph
  static TextStyle heroDescription = poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.6,
  );

  /// `.feature-text`
  static TextStyle heroFeature = poppins(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: AppColors.text,
  );

  /// Section eyebrow labels e.g. "OUR COLLECTIONS", "CURATED SELECTION"
  static TextStyle eyebrow = poppins(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 5,
    color: AppColors.crimson,
  );

  /// Section headings e.g. "Grace in every Thread"
  static TextStyle sectionTitle(double fontSize) => playfair(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      );

  /// `.sf-product-title`
  static TextStyle productTitle = playfair(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.35,
  );

  static TextStyle productSubtitle = poppins(
    fontSize: 12,
    color: AppColors.textMuted,
  );

  static TextStyle productCategory = poppins(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: AppColors.textLight,
  );

  static TextStyle priceCurrent = poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF1F1F1F),
  );

  static TextStyle priceOriginal = poppins(
    fontSize: 12,
    color: const Color(0xFF9A8F84),
  );

  static TextStyle buttonLabel = poppins(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  static TextStyle navLink = poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static TextStyle footerHeading = poppins(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 3,
    color: AppColors.gold,
  );

  static TextStyle footerLink = poppins(
    fontSize: 13,
    color: Colors.white70,
  );
}
