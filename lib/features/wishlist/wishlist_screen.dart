import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_navbar.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite_border, size: 56, color: AppColors.textLight),
              const SizedBox(height: 16),
              Text('Your wishlist is empty', style: AppTypography.playfair(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Tap the heart on any piece to save it here.',
                textAlign: TextAlign.center,
                style: AppTypography.poppins(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              PrimaryPillButton(label: 'EXPLORE COLLECTIONS', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
