import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_navbar.dart';
import '../../core/widgets/product_card.dart';
import '../../models/seed_products.dart';

/// Shop / Product Listing screen. Renders the full catalogue using the
/// same [ProductCard] as the homepage. Filtering by category/sidebar
/// (`.sf-sidebar`, `.sf-filter-row`, `.sf-sort`) is scoped for Phase 2 —
/// this stub establishes the grid shell and navigation entry point so
/// Phase 1 is fully runnable end-to-end.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = SeedProducts.all;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppNavBar(
        onMenuTap: () {},
        onSearchTap: () {},
        onWishlistTap: () {},
        onCartTap: () {},
        onProfileTap: () {},
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shop', style: AppTypography.sectionTitle(28)),
                  const SizedBox(height: 8),
                  Text(
                    '${products.length} pieces, handpicked for you',
                    style: AppTypography.poppins(fontSize: 13, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 14,
                childAspectRatio: 0.58,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    formatPrice: CurrencyFormatter.inr,
                    onTap: () {},
                    onQuickAdd: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.title} added to cart')),
                      );
                    },
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
