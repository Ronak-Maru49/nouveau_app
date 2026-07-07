import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/widgets/app_buttons.dart';
import '../core/widgets/logo_mark.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LogoMark(size: 64),
              const SizedBox(height: 24),
              Text('404', style: AppTypography.playfair(fontSize: 48, fontWeight: FontWeight.w700, color: AppColors.crimson)),
              const SizedBox(height: 8),
              Text('Page Not Found', style: AppTypography.playfair(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                "This thread doesn't lead anywhere — let's get you back.",
                textAlign: TextAlign.center,
                style: AppTypography.poppins(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              PrimaryPillButton(label: 'BACK TO HOME', onPressed: () => context.go('/')),
            ],
          ),
        ),
      ),
    );
  }
}
