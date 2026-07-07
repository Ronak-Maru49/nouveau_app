import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/logo_mark.dart';

/// "Our Philosophy" / "Where Every Thread Tells A Story" — brand story
/// copy plus a "Discover Our Story" CTA, with a decorative arch shape on
/// desktop (stacked below the text on mobile, matching the site's
/// `gridTemplateColumns: V ? '1fr' : '1fr 1fr'` collapse).
class PhilosophySection extends StatelessWidget {
  final VoidCallback onDiscoverStory;

  const PhilosophySection({super.key, required this.onDiscoverStory});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('OUR PHILOSOPHY', style: AppTypography.eyebrow),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: AppTypography.sectionTitle(30),
                  children: [
                    const TextSpan(text: 'Where Every Thread\n'),
                    TextSpan(
                      text: 'Tells A Story',
                      style: AppTypography.playfair(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppColors.crimson,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppConstants.philosophyParagraph1,
                style: AppTypography.poppins(
                  fontSize: 15,
                  color: AppColors.textMuted,
                  height: 1.85,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppConstants.philosophyParagraph2,
                style: AppTypography.poppins(
                  fontSize: 14,
                  color: AppColors.textMuted,
                  height: 1.85,
                ),
              ),
              const SizedBox(height: 28),
              PrimaryPillButton(
                label: 'DISCOVER OUR STORY',
                onPressed: onDiscoverStory,
                trailing: const Icon(Icons.arrow_forward, size: 14, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Decorative arch shape
          Center(
            child: Container(
              width: 260,
              height: 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.crimson, AppColors.crimsonDark],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(170),
                  topRight: Radius.circular(170),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(170),
                          topRight: Radius.circular(170),
                        ),
                        gradient: RadialGradient(
                          center: const Alignment(-0.4, -0.4),
                          radius: 0.9,
                          colors: [
                            AppColors.gold.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  const LogoMark(size: 140),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
