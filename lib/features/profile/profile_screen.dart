import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                child: const Icon(Icons.person_outline, size: 32, color: AppColors.crimson),
              ),
              const SizedBox(height: 16),
              Text('Welcome to Nouveau™', style: AppTypography.playfair(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Sign in to track orders, save your wishlist, and checkout faster.',
                textAlign: TextAlign.center,
                style: AppTypography.poppins(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              PrimaryPillButton(label: 'LOGIN', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
