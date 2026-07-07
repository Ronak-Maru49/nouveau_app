import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_navbar.dart';

/// Cart screen — Phase 1 ships the empty-state (mirrors `.sf-state`
/// dashed-border card copy pattern used across the site for empty
/// cart/wishlist/orders states). Full cart line-items, quantity
/// steppers, and checkout flow land in Phase 2 alongside the Cart
/// provider/repository.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
              const Icon(Icons.shopping_bag_outlined, size: 56, color: AppColors.textLight),
              const SizedBox(height: 16),
              Text('Your cart is empty', style: AppTypography.playfair(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Looks like you haven\'t added anything yet.',
                textAlign: TextAlign.center,
                style: AppTypography.poppins(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              PrimaryPillButton(label: 'START SHOPPING', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
