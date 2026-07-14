import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/wishlist_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_buttons.dart';
import '../../models/product_model.dart';

Future<void> showProductDetails(BuildContext context, Product product) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ProductDetailSheet(product: product),
  );
}

class _ProductDetailSheet extends StatefulWidget {
  final Product product;

  const _ProductDetailSheet({required this.product});

  @override
  State<_ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<_ProductDetailSheet> {
  late String _size = widget.product.sizes.isNotEmpty
      ? widget.product.sizes.first.size
      : 'Free Size';
  int _quantity = 1;

  void _addToCart() {
    final cart = context.read<CartProvider>();
    for (var i = 0; i < _quantity; i++) {
      cart.add(widget.product, size: _size);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product.title} added to cart')),
    );
  }

  void _buyNow() {
    final router = GoRouter.of(context);
    _addToCart();
    Navigator.of(context).pop();
    router.go('/cart');
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final wishlist = context.watch<WishlistProvider>();
    final isWishlisted = wishlist.contains(product.id);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.55,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Align(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.borderDark,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: _DetailImage(
                      path: product.primaryImage, title: product.title),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.category.toUpperCase(),
                            style: AppTypography.productCategory),
                        const SizedBox(height: 8),
                        Text(
                          product.title,
                          style: AppTypography.playfair(
                              fontSize: 28, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(product.subcategory,
                            style: AppTypography.poppins(
                                color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () =>
                        context.read<WishlistProvider>().toggle(product),
                    icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border),
                    color: AppColors.crimson,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(CurrencyFormatter.inr(product.price),
                      style: AppTypography.sectionTitle(26)),
                  if (product.hasDiscount) ...[
                    const SizedBox(width: 10),
                    Text(
                      CurrencyFormatter.inr(product.originalPrice),
                      style: AppTypography.priceOriginal
                          .copyWith(decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(width: 10),
                    Text('${product.discount}% OFF',
                        style: AppTypography.poppins(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700)),
                  ],
                ],
              ),
              const SizedBox(height: 18),
              _RatingAndStock(product: product),
              const SizedBox(height: 20),
              Text('Size',
                  style: AppTypography.poppins(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (product.sizes.isEmpty
                        ? const [ProductSize(size: 'Free Size', quantity: 1)]
                        : product.sizes)
                    .map(
                      (size) => ChoiceChip(
                        label: Text(size.size),
                        selected: _size == size.size,
                        selectedColor: AppColors.accent,
                        onSelected: size.quantity <= 0
                            ? null
                            : (_) => setState(() => _size = size.size),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              Text('Quantity',
                  style: AppTypography.poppins(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton.outlined(
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 48,
                    child: Text('$_quantity',
                        textAlign: TextAlign.center,
                        style: AppTypography.poppins(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  IconButton.outlined(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Product details',
                  style: AppTypography.poppins(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(product.description,
                  style: AppTypography.poppins(
                      color: AppColors.textMuted, height: 1.6)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinePillButton(
                      label: 'ADD TO CART',
                      onPressed: product.isOutOfStock ? null : _addToCart,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryPillButton(
                      label: 'BUY NOW',
                      disabled: product.isOutOfStock,
                      onPressed: _buyNow,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RatingAndStock extends StatelessWidget {
  final Product product;

  const _RatingAndStock({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          5,
          (index) => Icon(
              index < product.rating.round() ? Icons.star : Icons.star_border,
              size: 16,
              color: AppColors.gold),
        ),
        const SizedBox(width: 6),
        Text('(${product.reviews})',
            style: AppTypography.poppins(color: AppColors.textMuted)),
        const Spacer(),
        Text(
          product.isOutOfStock ? 'Out of stock' : '${product.stock} in stock',
          style: AppTypography.poppins(
            color:
                product.isOutOfStock ? AppColors.outOfStock : AppColors.success,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DetailImage extends StatelessWidget {
  final String path;
  final String title;

  const _DetailImage({required this.path, required this.title});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        path.startsWith('http') ? path : 'https://www.nouveauz.com$path';
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        alignment: Alignment.center,
        color: AppColors.accent,
        padding: const EdgeInsets.all(24),
        child: Text(title,
            textAlign: TextAlign.center, style: AppTypography.sectionTitle(24)),
      ),
    );
  }
}
