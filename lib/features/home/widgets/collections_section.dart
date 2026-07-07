import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/logo_mark.dart';

/// "Our Collections" / "Grace in every Thread" — two large gradient
/// category cards (Indian Ethnic Wear / Indian Western Wear), each with
/// an aesthetic count badge, title, and Explore link. Stacked vertically
/// on mobile (site: `gridTemplateColumns: V ? '1fr' : '1fr 1fr'`).
class CollectionsSection extends StatelessWidget {
  final int ethnicWearCount;
  final int westernWearCount;
  final VoidCallback onEthnicWearTap;
  final VoidCallback onWesternWearTap;

  const CollectionsSection({
    super.key,
    required this.ethnicWearCount,
    required this.westernWearCount,
    required this.onEthnicWearTap,
    required this.onWesternWearTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgCard,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: Column(
        children: [
          Text('OUR COLLECTIONS', style: AppTypography.eyebrow),
          const SizedBox(height: 12),
          Text(
            'Grace in every Thread',
            textAlign: TextAlign.center,
            style: AppTypography.sectionTitle(30),
          ),
          const SizedBox(height: 20),
          _CollectionCard(
            title: 'Indian Ethnic\nWear',
            badgeLabel: '$ethnicWearCount AESTHETICS',
            badgeColor: AppColors.gold,
            gradientColors: const [AppColors.crimsonDark, Color(0xFF9F5B65)],
            exploreColor: AppColors.gold,
            onTap: onEthnicWearTap,
          ),
          const SizedBox(height: 24),
          _CollectionCard(
            title: 'Indian\nWestern Wear',
            badgeLabel: '$westernWearCount AESTHETICS',
            badgeColor: AppColors.crimson,
            gradientColors: const [
              AppColors.westernWearGradientStart,
              AppColors.westernWearGradientEnd,
            ],
            exploreColor: AppColors.goldLight,
            onTap: onWesternWearTap,
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final String title;
  final String badgeLabel;
  final Color badgeColor;
  final List<Color> gradientColors;
  final Color exploreColor;
  final VoidCallback onTap;

  const _CollectionCard({
    required this.title,
    required this.badgeLabel,
    required this.badgeColor,
    required this.gradientColors,
    required this.exploreColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
          child: Stack(
            children: [
              const Positioned(
                top: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.32,
                  child: LogoMark(size: 100),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badgeLabel,
                        style: AppTypography.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      title,
                      style: AppTypography.sectionTitle(28).copyWith(
                            color: Colors.white,
                            height: 1.2,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'EXPLORE',
                          style: AppTypography.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: exploreColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 16, color: exploreColor),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
