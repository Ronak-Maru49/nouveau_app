import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/cart_provider.dart';
import 'core/providers/wishlist_provider.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';

void main() {
  // Avoids runtime font fetches failing noisily if the device is briefly
  // offline; google_fonts still fetches Playfair Display / Poppins from
  // the network on first use to match the site's own Google Fonts CDN
  // import, then caches them locally.
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(const NouveauApp());
}

class NouveauApp extends StatelessWidget {
  const NouveauApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp.router(
        title: 'Nouveau™ — Own Your Aura',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}
