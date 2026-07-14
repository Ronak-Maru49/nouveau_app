import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/wishlist_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_navbar.dart';
import '../../core/widgets/product_card.dart';
import '../shop/product_detail_sheet.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppNavBar(
        cartCount: cart.itemCount,
        isAuthenticated: auth.isAuthenticated,
        userInitials: auth.user?.initials,
        onMenuTap: () {},
        onSearchTap: () {},
        onWishlistTap: () {},
        onCartTap: () => context.go('/cart'),
        onProfileTap: () => context.go('/profile'),
      ),
      body: wishlist.items.isEmpty
          ? const _EmptyWishlist()
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: wishlist.items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 14,
                childAspectRatio: 0.34,
              ),
              itemBuilder: (context, index) {
                final product = wishlist.items[index];
                return ProductCard(
                  key: ValueKey(product.id),
                  product: product,
                  formatPrice: CurrencyFormatter.inr,
                  initiallyWishlisted: true,
                  onTap: () => showProductDetails(context, product),
                  onWishlistToggle: (_) =>
                      context.read<WishlistProvider>().toggle(product),
                  onQuickAdd: () {
                    context.read<CartProvider>().add(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.title} added to cart')),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border,
                size: 56, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text('Your wishlist is empty',
                style: AppTypography.playfair(
                    fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Tap the heart on any piece to save it here.',
                textAlign: TextAlign.center,
                style: AppTypography.poppins(color: AppColors.textMuted)),
            const SizedBox(height: 24),
            PrimaryPillButton(
                label: 'EXPLORE COLLECTIONS',
                onPressed: () => context.go('/shop')),
          ],
        ),
      ),
    );
  }
}
