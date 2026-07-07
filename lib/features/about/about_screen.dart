import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_navbar.dart';
import '../../core/widgets/logo_mark.dart';
import '../../core/widgets/app_footer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppNavBar(
        onMenuTap: () {},
        onSearchTap: () {},
        onWishlistTap: () {},
        onCartTap: () {},
        onProfileTap: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                children: [
                  const LogoMark(size: 64),
                  const SizedBox(height: 16),
                  Text('nouveau™', style: AppTypography.playfair(fontSize: 28, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.brandTaglineAlt,
                    style: AppTypography.poppins(fontSize: 12, letterSpacing: 3, color: AppColors.crimson),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    AppConstants.philosophyParagraph1,
                    textAlign: TextAlign.center,
                    style: AppTypography.poppins(fontSize: 15, color: AppColors.textMuted, height: 1.85),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppConstants.philosophyParagraph2,
                    textAlign: TextAlign.center,
                    style: AppTypography.poppins(fontSize: 15, color: AppColors.textMuted, height: 1.85),
                  ),
                ],
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
