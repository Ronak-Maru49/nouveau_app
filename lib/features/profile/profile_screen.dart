import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppNavBar(
        cartCount: cart.itemCount,
        isAuthenticated: auth.isAuthenticated,
        userInitials: user?.initials,
        onMenuTap: () {},
        onSearchTap: () {},
        onWishlistTap: () => context.go('/wishlist'),
        onCartTap: () => context.go('/cart'),
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
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: AppColors.avatarBrown, shape: BoxShape.circle),
                child: Text(user?.initials ?? 'U',
                    style: AppTypography.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              const SizedBox(height: 16),
              Text(user?.name ?? 'Nouveau customer',
                  style: AppTypography.playfair(
                      fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(user?.email ?? '',
                  textAlign: TextAlign.center,
                  style: AppTypography.poppins(color: AppColors.textMuted)),
              const SizedBox(height: 24),
              PrimaryPillButton(
                label: 'LOGOUT',
                onPressed: () => context.read<AuthProvider>().signOut(),
                trailing:
                    const Icon(Icons.logout, color: Colors.white, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
