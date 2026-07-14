import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/product_card.dart';
import '../../../models/product_model.dart';

/// Reusable two-column product grid section with an eyebrow/title header
/// and a trailing "View All" action — used for both "New Arrivals"
/// (`Curated Selection`) and "Trending Now" (`Bestsellers`) on the
/// homepage, matching the site's `sf-products-grid` breakpoints (2 cols
/// on mobile, up to 4 on desktop — we use 2 for phone-width native UI).
class ProductGridSection extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final List<Product> products;
  final Color background;
  final VoidCallback onViewAll;
  final void Function(Product) onProductTap;
  final void Function(Product) onQuickAdd;
  final bool Function(String productId)? isWishlisted;
  final void Function(Product)? onWishlistToggle;
  final bool compact;

  const ProductGridSection({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.products,
    required this.onViewAll,
    required this.onProductTap,
    required this.onQuickAdd,
    this.isWishlisted,
    this.onWishlistToggle,
    this.subtitle,
    this.background = AppColors.bg,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(eyebrow.toUpperCase(), style: AppTypography.eyebrow),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.sectionTitle(28),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 16),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTypography.poppins(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.7,
              ),
            ),
          ],
          const SizedBox(height: 28),
          if (products.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Loading collections...',
                style: AppTypography.poppins(color: AppColors.textMuted),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 14,
                childAspectRatio: 0.34,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  key: ValueKey(
                      '${product.id}-${isWishlisted?.call(product.id) ?? false}'),
                  product: product,
                  formatPrice: CurrencyFormatter.inr,
                  compact: compact,
                  initiallyWishlisted: isWishlisted?.call(product.id) ?? false,
                  onWishlistToggle: (_) => onWishlistToggle?.call(product),
                  onTap: () => onProductTap(product),
                  onQuickAdd: () => onQuickAdd(product),
                );
              },
            ),
          const SizedBox(height: 32),
          OutlinePillButton(
            label: 'VIEW ALL COLLECTIONS',
            onPressed: onViewAll,
            trailing: const Icon(Icons.arrow_forward,
                size: 14, color: AppColors.crimson),
          ),
        ],
      ),
    );
  }
}
