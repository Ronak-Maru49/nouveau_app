import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'logo_mark.dart';

/// Sticky glass navbar matching `.sf-navbar` (backdrop-blur, translucent
/// white, bottom border, logo + wordmark, action icons with cart badge,
/// avatar). On mobile the site collapses nav links/search into a drawer —
/// this widget mirrors that breakpoint behaviour via [showSearch].
class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onSearchTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onCartTap;
  final VoidCallback onProfileTap;
  final int cartCount;
  final bool isAuthenticated;
  final String? userInitials;

  const AppNavBar({
    super.key,
    required this.onMenuTap,
    required this.onSearchTap,
    required this.onWishlistTap,
    required this.onCartTap,
    required this.onProfileTap,
    this.cartCount = 0,
    this.isAuthenticated = false,
    this.userInitials,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            border: const Border(bottom: BorderSide(color: AppColors.border)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  const LogoMark(size: 34),
                  const SizedBox(width: 6),
                  Text(
                    'nouveau™',
                    style: AppTypography.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  _IconAction(icon: Icons.search, onTap: onSearchTap),
                  _IconAction(
                    icon: Icons.favorite_border,
                    onTap: onWishlistTap,
                  ),
                  _IconAction(
                    icon: Icons.shopping_bag_outlined,
                    onTap: onCartTap,
                    badgeCount: cartCount,
                  ),
                  const SizedBox(width: 4),
                  _ProfileAvatar(
                    isAuthenticated: isAuthenticated,
                    initials: userInitials,
                    onTap: onProfileTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int badgeCount;

  const _IconAction({required this.icon, required this.onTap, this.badgeCount = 0});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(child: Icon(icon, size: 21, color: AppColors.text)),
              if (badgeCount > 0)
                Positioned(
                  right: 2,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    height: 16,
                    constraints: const BoxConstraints(minWidth: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final bool isAuthenticated;
  final String? initials;
  final VoidCallback onTap;

  const _ProfileAvatar({required this.isAuthenticated, this.initials, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isAuthenticated ? AppColors.avatarBrown : AppColors.accent,
            shape: BoxShape.circle,
          ),
          child: isAuthenticated
              ? Text(
                  initials ?? 'U',
                  style: AppTypography.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.person_outline, size: 18, color: AppColors.text),
        ),
      ),
    );
  }
}
