import 'package:go_router/go_router.dart';
import '../features/about/about_screen.dart';
import '../features/cart/cart_screen.dart';
import '../features/contact/contact_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/shop/shop_screen.dart';
import '../features/wishlist/wishlist_screen.dart';
import 'not_found_screen.dart';
import 'root_shell.dart';
import 'splash_screen.dart';

/// App-wide routing. `RootShell` owns the bottom-tab navigation for the
/// primary IA (Home / Shop / Wishlist / Cart / Profile); About and
/// Contact are pushed on top as full-screen routes, matching how the
/// site treats them as standalone pages reachable from the footer.
///
/// Deep-linkable routes for Service/Product detail, Blog, Careers, etc.
/// will be added in Phase 2 once the corresponding screens are built —
/// paths are reserved here as comments so the route table's final shape
/// is visible up front.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const RootShell(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactScreen(),
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state) => const ShopScreen(),
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    // --- Reserved for Phase 2 ---
    // GoRoute(path: '/product/:id', builder: ...ProductDetailScreen),
    // GoRoute(path: '/blog', builder: ...BlogScreen),
    // GoRoute(path: '/blog/:slug', builder: ...BlogDetailScreen),
    // GoRoute(path: '/careers', builder: ...CareersScreen),
    // GoRoute(path: '/settings', builder: ...SettingsScreen),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
