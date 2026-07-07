import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_footer.dart';
import '../../core/widgets/app_navbar.dart';
import '../../core/widgets/marquee_ticker.dart';
import '../../models/product_model.dart';
import '../../models/seed_products.dart';
import '../../navigation/app_drawer.dart';
import 'widgets/collections_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/philosophy_section.dart';
import 'widgets/product_grid_section.dart';

/// Home screen — assembles every homepage section in the exact order
/// found in the compiled bundle (module 9601, default export `j`):
///
///   1. Navbar (sticky)
///   2. Hero ("Wear Your Aura")
///   3. Marquee ticker
///   4. Collections (Ethnic / Western gradient cards)
///   5. New Arrivals (Curated Selection)
///   6. Our Philosophy
///   7. Trending Now (Bestsellers)
///   8. Footer
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _cartCount = 0;

  void _addToCart(Product product) {
    setState(() => _cartCount++);
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
    // Phase 2 will wire this to a real ProductDetail route via go_router.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open product: ${product.title}')),
    );
  }

  void _goToShop({String? category}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to Shop${category != null ? ' → $category' : ''}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bg,
      drawer: const AppDrawer(),
      appBar: AppNavBar(
        cartCount: _cartCount,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onSearchTap: () {},
        onWishlistTap: () {},
        onCartTap: () => _goToShop(),
        onProfileTap: () {},
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
              onWesternWearTap: () => _goToShop(category: 'Indian Western Wear'),
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
              ),
            ),
            AppFooter(onNavigate: (page) => _goToShop(category: page)),
          ],
        ),
      ),
    );
  }
}
