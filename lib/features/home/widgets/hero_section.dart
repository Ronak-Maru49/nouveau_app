import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/logo_mark.dart';

/// Hero section — mirrors `.hero-wrapper` in its **mobile** configuration
/// (the site's own `@media (max-width: 768px)` rules), since this is a
/// native mobile app:
///   - background hero image fills the top ~55% of the viewport, faded
///     into the background color at the bottom via a gradient mask
///   - logo mark top-left
///   - centered content below: golden ornament, gradient headline
///     "Wear Your Aura", uppercase subtitle, description, full-width
///     gold "Shop Now" button, and a 3-up feature row with dividers
class HeroSection extends StatelessWidget {
  final VoidCallback onShopNow;

  const HeroSection({super.key, required this.onShopNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.heroBg,
      child: Column(
        children: [
          // --- hero-bg-container / hero-bg-image ---
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 380,
                child: Image.asset(
                  'assets/images/hero_banner.png',
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.6, -0.4),
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.crimsonLight, AppColors.heroGoldOrnament],
                      ),
                    ),
                  ),
                ),
              ),
              // fade to hero bg at the bottom, matching hero-bg-container::after
              Positioned(
                left: 0,
                right: 0,
                bottom: -1,
                height: 120,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppColors.heroBg, Colors.transparent],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 16,
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      const LogoMark(size: 28),
                      const SizedBox(width: 6),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'nouveau',
                              style: AppTypography.playfair(
                                fontSize: 22,
                                color: const Color(0xFF222222),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: '™',
                              style: AppTypography.poppins(
                                fontSize: 11,
                                color: AppColors.heroGoldOrnament,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- hero-main / hero-content (mobile: centered, margin-top: -50px) ---
          Transform.translate(
            offset: const Offset(0, -40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // golden-ornament
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: AppColors.heroGoldOrnament)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: LogoMark(size: 22),
                      ),
                      Expanded(child: Container(height: 1, color: AppColors.heroGoldOrnament)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // main-title — gradient text via ShaderMask
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppColors.heroGradientStart,
                        AppColors.heroGradientMid,
                        AppColors.heroGradientEnd,
                      ],
                      stops: [0.0, 0.3, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      AppConstants.brandTagline,
                      textAlign: TextAlign.center,
                      style: AppTypography.heroTitle(42).copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // subtitle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppConstants.brandSubtitle,
                        style: AppTypography.heroSubtitle.copyWith(fontSize: 10, letterSpacing: 2),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.star, size: 14, color: AppColors.goldDark),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // description
                  Text(
                    AppConstants.heroDescription,
                    textAlign: TextAlign.center,
                    style: AppTypography.heroDescription.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 32),

                  // hero-actions — full width shop button
                  HeroShopButton(label: 'Shop Now', onPressed: onShopNow),
                  const SizedBox(height: 40),

                  // features-row
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Feature(lines: ['PREMIUM', 'QUALITY']),
                      _FeatureDivider(),
                      _Feature(lines: ['TIMELESS', 'DESIGNS']),
                      _FeatureDivider(),
                      _Feature(lines: ['MADE FOR', 'YOU']),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final List<String> lines;
  const _Feature({required this.lines});

  @override
  Widget build(BuildContext context) {
    return Text(
      lines.join('\n'),
      textAlign: TextAlign.center,
      style: AppTypography.heroFeature.copyWith(fontSize: 8, letterSpacing: 1),
    );
  }
}

class _FeatureDivider extends StatelessWidget {
  const _FeatureDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.heroGoldOrnament.withValues(alpha: 0.3),
    );
  }
}
