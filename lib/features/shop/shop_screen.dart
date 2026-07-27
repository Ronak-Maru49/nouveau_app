import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/wishlist_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_navbar.dart';
import '../../core/widgets/product_card.dart';
import '../../models/seed_products.dart';
import 'product_detail_sheet.dart';

class _CollectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _CollectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.crimson, size: 24),
          const SizedBox(height: 10),
          Text(title, style: AppTypography.poppins(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.poppins(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _category = 'All';
  String _sort = 'Featured';
  RangeValues _price = const RangeValues(0, 5000);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final categories = [
      'All',
      ...SeedProducts.all.map((p) => p.category).toSet()
    ];
    var products = SeedProducts.all.where((p) {
      final categoryOk = _category == 'All' || p.category == _category;
      final priceOk = p.price >= _price.start && p.price <= _price.end;
      return categoryOk && priceOk;
    }).toList();

    if (_sort == 'Price low') {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sort == 'Price high') {
      products.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sort == 'New') {
      products.sort((a, b) => b.isNew.toString().compareTo(a.isNew.toString()));
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppNavBar(
        cartCount: cart.itemCount,
        isAuthenticated: auth.isAuthenticated,
        userInitials: auth.user?.initials,
        onMenuTap: () {},
        onSearchTap: () {},
        onWishlistTap: () => context.go('/wishlist'),
        onCartTap: () => context.go('/cart'),
        onProfileTap: () => context.go('/profile'),
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
                    style: AppTypography.poppins(
                        fontSize: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 132,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _CollectionCard(
                          title: 'Signature Edit',
                          subtitle: 'Elevated staples for every occasion',
                          icon: Icons.auto_awesome,
                        ),
                        SizedBox(width: 12),
                        _CollectionCard(
                          title: 'Festive Edit',
                          subtitle:
                              'Rich textures, jewel tones, statement silhouettes',
                          icon: Icons.celebration,
                        ),
                        SizedBox(width: 12),
                        _CollectionCard(
                          title: 'Modern Minimal',
                          subtitle: 'Polished essentials with clean lines',
                          icon: Icons.style,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories
                        .map(
                          (category) => ChoiceChip(
                            label: Text(category),
                            selected: _category == category,
                            selectedColor: AppColors.accent,
                            onSelected: (_) =>
                                setState(() => _category = category),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Price: ${CurrencyFormatter.inr(_price.start)} - ${CurrencyFormatter.inr(_price.end)}',
                          style: AppTypography.poppins(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                      ),
                      DropdownButton<String>(
                        value: _sort,
                        underline: const SizedBox.shrink(),
                        items: const [
                          'Featured',
                          'New',
                          'Price low',
                          'Price high'
                        ]
                            .map((s) =>
                                DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _sort = value ?? 'Featured'),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _price,
                    min: 0,
                    max: 5000,
                    divisions: 20,
                    activeColor: AppColors.crimson,
                    labels: RangeLabels(CurrencyFormatter.inr(_price.start),
                        CurrencyFormatter.inr(_price.end)),
                    onChanged: (value) => setState(() => _price = value),
                  ),
                ],
              ),
            ),
          ),
          SliverLayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.crossAxisExtent;
              final columns = width >= 1200
                  ? 4
                  : width >= 820
                      ? 3
                      : 2;
              final ratio = width >= 1200
                  ? 0.42
                  : width >= 820
                      ? 0.38
                      : 0.30;

              return SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  width >= 820 ? 32 : 20,
                  12,
                  width >= 820 ? 32 : 20,
                  32,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 14,
                    childAspectRatio: ratio,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return ProductCard(
                        key: ValueKey(
                            '${product.id}-${wishlist.contains(product.id)}'),
                        product: product,
                        formatPrice: CurrencyFormatter.inr,
                        initiallyWishlisted: wishlist.contains(product.id),
                        onWishlistToggle: (_) => wishlist.toggle(product),
                        onTap: () => showProductDetails(context, product),
                        onQuickAdd: () {
                          context.read<CartProvider>().add(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('${product.title} added to cart')),
                          );
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
