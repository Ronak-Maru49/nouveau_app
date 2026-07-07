import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Filled pill button with the crimson→dark-red gradient used across the
/// site's primary CTAs (e.g. "Quick Add", hero-adjacent actions).
/// Mirrors component `h.PA` from the compiled bundle.
class PrimaryPillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? trailing;
  final bool disabled;
  final EdgeInsetsGeometry padding;

  const PrimaryPillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.trailing,
    this.disabled = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: disabled ? null : onPressed,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
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
                      color: AppColors.primaryBtnDarkRed.withValues(alpha: 0.2),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.buttonLabel.copyWith(color: Colors.white),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Outlined pill button. Mirrors component `h.l1`.
class OutlinePillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? trailing;
  final Color color;

  const OutlinePillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.trailing,
    this.color = AppColors.crimson,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.buttonLabel.copyWith(color: color),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Solid gold/brown shop button used in the hero (`.btn-shop`).
class HeroShopButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const HeroShopButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.heroShopBtn,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: AppColors.heroShopBtn.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            label,
            style: AppTypography.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
