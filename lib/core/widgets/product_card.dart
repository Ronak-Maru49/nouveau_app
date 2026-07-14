import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Product card matching `.sf-product-card` / component `g.A` (module
/// 6596) pixel-for-pixel in structure: 3:4 media, wishlist heart,
/// out-of-stock ribbon, category label, star rating, Playfair title,
/// subtitle, price row, and a two-button action row (View / Quick Add).
class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onQuickAdd;
  final bool compact;
  final bool initiallyWishlisted;
  final ValueChanged<bool>? onWishlistToggle;
  final String Function(double) formatPrice;

  const ProductCard({
    super.key,
    required this.product,
    required this.formatPrice,
    this.onTap,
    this.onQuickAdd,
    this.compact = false,
    this.initiallyWishlisted = false,
    this.onWishlistToggle,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _wishlisted = widget.initiallyWishlisted;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final outOfStock = p.isOutOfStock;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D3F2621),
            blurRadius: 32,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- sf-product-media ---
          GestureDetector(
            onTap: widget.onTap,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                    color: AppColors.accent,
                    child: _ProductImage(path: p.primaryImage, title: p.title),
                  ),
                ),
                if (outOfStock)
                  Positioned(
                    left: 14,
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.outOfStock.withValues(alpha: 0.18),
                            width: 1.5),
                      ),
                      child: Text(
                        'SOLD OUT',
                        style: AppTypography.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.outOfStock,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: _WishlistButton(
                    filled: _wishlisted,
                    onTap: () {
                      setState(() => _wishlisted = !_wishlisted);
                      widget.onWishlistToggle?.call(_wishlisted);
                    },
                  ),
                ),
              ],
            ),
          ),
          // --- sf-product-body ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.category.toUpperCase(),
                      style: AppTypography.productCategory),
                  const SizedBox(height: 6),
                  _RatingRow(rating: p.rating, count: p.reviews),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      p.title,
                      style: AppTypography.productTitle.copyWith(
                        fontSize: widget.compact ? 15 : 17,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.subcategory,
                    style: AppTypography.productSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(widget.formatPrice(p.price),
                          style: AppTypography.priceCurrent),
                      if (p.hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          widget.formatPrice(p.originalPrice),
                          style: AppTypography.priceOriginal.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: _OutlineActionButton(
                          label: 'View',
                          onTap: widget.onTap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _PrimaryActionButton(
                          label: outOfStock ? 'Sold Out' : 'Add',
                          disabled: outOfStock,
                          onTap: outOfStock ? null : widget.onQuickAdd,
                        ),
                      ),
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

class _ProductImage extends StatelessWidget {
  final String path;
  final String title;
  const _ProductImage({required this.path, required this.title});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        path.startsWith('http') ? path : 'https://www.nouveauz.com$path';
    return Semantics(
      label: title,
      image: true,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _ProductImageFallback(title: title);
        },
        errorBuilder: (context, error, stackTrace) =>
            _ProductImageFallback(title: title),
      ),
    );
  }
}

class _ProductImageFallback extends StatelessWidget {
  final String title;
  const _ProductImageFallback({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent, AppColors.bgDark],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.checkroom,
              size: 42, color: AppColors.crimson.withValues(alpha: 0.35)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  final bool filled;
  final VoidCallback onTap;
  const _WishlistButton({required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.95),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            filled ? Icons.favorite : Icons.favorite_border,
            size: 18,
            color: AppColors.crimson,
          ),
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final double rating;
  final int count;
  const _RatingRow({required this.rating, required this.count});

  @override
  Widget build(BuildContext context) {
    final rounded = rating.round();
    return Row(
      children: [
        ...List.generate(5, (i) {
          final filled = (i + 1) <= rounded;
          return Icon(
            filled ? Icons.star : Icons.star_border,
            size: 13,
            color: AppColors.gold,
          );
        }),
        if (count > 0) ...[
          const SizedBox(width: 4),
          Text(
            '($count)',
            style:
                AppTypography.poppins(fontSize: 12, color: AppColors.textLight),
          ),
        ],
      ],
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _OutlineActionButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppColors.text,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final String label;
  final bool disabled;
  final VoidCallback? onTap;
  const _PrimaryActionButton(
      {required this.label, required this.disabled, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white.withValues(alpha: 0.15),
        highlightColor: Colors.white.withValues(alpha: 0.08),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: disabled
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryBtnRed,
                      AppColors.primaryBtnDarkRed,
                    ],
                  ),
            color: disabled ? AppColors.border : null,
            boxShadow: disabled
                ? null
                : [
                    BoxShadow(
                      color:
                          AppColors.primaryBtnDarkRed.withValues(alpha: 0.28),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!disabled) ...[
                const Icon(
                  Icons.add_shopping_cart_rounded,
                  size: 13,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: AppTypography.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: disabled ? AppColors.textMuted : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}