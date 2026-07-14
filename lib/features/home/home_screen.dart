import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/wishlist_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_footer.dart';
import '../../core/widgets/app_navbar.dart';
import '../../core/widgets/marquee_ticker.dart';
import '../../models/product_model.dart';
import '../../models/seed_products.dart';
import '../../navigation/app_drawer.dart';
import '../shop/product_detail_sheet.dart';
import 'widgets/collections_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/philosophy_section.dart';
import 'widgets/product_grid_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _addToCart(Product product) {
    context.read<CartProvider>().add(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        backgroundColor: AppColors.crimson,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openProduct(Product product) {
    showProductDetails(context, product);
  }

  void _goToShop({String? category}) => context.go('/shop');

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bg,
      drawer: const AppDrawer(),
      appBar: AppNavBar(
        cartCount: cart.itemCount,
        isAuthenticated: auth.isAuthenticated,
        userInitials: auth.user?.initials,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onSearchTap: () {},
        onWishlistTap: () => context.go('/wishlist'),
        onCartTap: () => context.go('/cart'),
        onProfileTap: () => context.go('/profile'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            HeroSection(onShopNow: () => _goToShop()),
            const MarqueeTicker(),
            CollectionsSection(
              ethnicWearCount: SeedProducts.ethnicWear.length,
              westernWearCount: SeedProducts.westernWear.length,
              onEthnicWearTap: () => _goToShop(category: 'Indian Ethnic Wear'),
              onWesternWearTap: () =>
                  _goToShop(category: 'Indian Western Wear'),
            ),
            ProductGridSection(
              eyebrow: 'Curated Selection',
              title: 'New Arrivals',
              subtitle: AppConstants.newArrivalsBlurb,
              products: SeedProducts.newArrivals,
              background: AppColors.bg,
              onViewAll: () => _goToShop(),
              onProductTap: _openProduct,
              onQuickAdd: _addToCart,
              isWishlisted: wishlist.contains,
              onWishlistToggle: (product) =>
                  context.read<WishlistProvider>().toggle(product),
            ),
            PhilosophySection(onDiscoverStory: () {}),
            Container(
              color: AppColors.bgDark,
              child: ProductGridSection(
                eyebrow: 'Bestsellers',
                title: 'Trending Now',
                products: SeedProducts.trending,
                background: AppColors.bgDark,
                compact: true,
                onViewAll: () => _goToShop(),
                onProductTap: _openProduct,
                onQuickAdd: _addToCart,
                isWishlisted: wishlist.contains,
                onWishlistToggle: (product) =>
                    context.read<WishlistProvider>().toggle(product),
              ),
            ),
            AppFooter(onNavigate: (_) => _goToShop()),
          ],
        ),
      ),
    );
  }
}
