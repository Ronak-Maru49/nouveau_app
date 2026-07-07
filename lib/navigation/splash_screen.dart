import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/widgets/logo_mark.dart';

/// Splash screen — brand mark on the site's warm bg tone, fading in and
/// handing off to the root shell. The site itself has no splash (it's a
/// web SPA), so this is a native-appropriate addition using the same
/// brand palette and Playfair wordmark treatment as the navbar/footer.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<double> _scale = Tween<double>(begin: 0.9, end: 1.0)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) context.go('/');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.heroBg,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LogoMark(size: 96),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: AppTypography.playfair(fontSize: 30, fontWeight: FontWeight.w600, color: AppColors.text),
                    children: const [
                      TextSpan(text: 'nouveau'),
                      TextSpan(text: '™', style: TextStyle(color: AppColors.goldDark, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'OWN YOUR AURA',
                  style: AppTypography.poppins(fontSize: 11, letterSpacing: 4, color: AppColors.crimson),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
