import 'package:flutter/material.dart';

/// Color palette extracted verbatim from the production bundle of
/// nouveauz.com (the `CV` theme object, module 8114 of main.f3c214b5.js).
///
/// Do not "improve" or re-tune these values — they are the brand's
/// actual design tokens, not placeholders.
class AppColors {
  AppColors._();

  // --- Primary brand tones -------------------------------------------------
  static const Color crimson = Color(0xFFB76E79);
  static const Color crimsonDark = Color(0xFF9F5B65);
  static const Color crimsonLight = Color(0xFFCB8F97);

  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFE4C76D);
  static const Color goldDark = Color(0xFFB8962E);

  // --- Surfaces --------------------------------------------------------------
  static const Color bg = Color(0xFFFAF7F2);
  static const Color bgDark = Color(0xFFF3EDE5);
  static const Color accent = Color(0xFFEADBD2);
  static const Color bgCard = Color(0xFFFFFFFF);

  // --- Text --------------------------------------------------------------
  static const Color text = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF555555);
  static const Color textLight = Color(0xFF8D8177);

  // --- Borders -------------------------------------------------------------
  static const Color border = Color(0xFFEADBD2);
  static const Color borderDark = Color(0xFFDDCBC2);

  // --- Secondary accents seen in component-level styles (product actions,
  // hero CTA, footer, etc.) that live outside the shared CV object -------
  static const Color heroBg = Color(0xFFFDFAF7);
  static const Color heroGoldOrnament = Color(0xFFC89D53);
  static const Color heroGradientStart = Color(0xFFAC4A5B);
  static const Color heroGradientMid = Color(0xFFC47671);
  static const Color heroGradientEnd = Color(0xFFC89D53);
  static const Color heroShopBtn = Color(0xFFBB864C);
  static const Color heroShopBtnHover = Color(0xFFA46D2F);

  static const Color primaryBtnRed = Color(0xFFB71C1C);
  static const Color primaryBtnDarkRed = Color(0xFF8B0000);

  static const Color westernWearGradientStart = Color(0xFF2A1A00);
  static const Color westernWearGradientEnd = Color(0xFF6B5000);

  static const Color success = Color(0xFF22C55E);
  static const Color outOfStock = Color(0xFFB71C1C);
  static const Color avatarBrown = Color(0xFF8B4513);

  static const Color footerBg = crimson;
  static const Color footerAccent = Color(0xFFC9A227);
}
