import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/widgets/logo_mark.dart';

/// Mobile navigation drawer — the native equivalent of the site's
/// hamburger-triggered mobile nav overlay, which lists the same links as
/// the desktop navbar (Home / Shop / About / Contact) plus quick access
/// to Wishlist/Cart and social links from the footer.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  const LogoMark(size: 36),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      style: AppTypography.playfair(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.text),
                      children: const [
                        TextSpan(text: 'nouveau'),
                        TextSpan(text: '™', style: TextStyle(color: AppColors.goldDark, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _DrawerLink(icon: Icons.home_outlined, label: 'Home', onTap: () { Navigator.pop(context); context.go('/'); }),
            _DrawerLink(icon: Icons.storefront_outlined, label: 'Shop', onTap: () { Navigator.pop(context); context.go('/shop'); }),
            _DrawerLink(icon: Icons.info_outline, label: 'About Us', onTap: () { Navigator.pop(context); context.go('/about'); }),
            _DrawerLink(icon: Icons.mail_outline, label: 'Contact', onTap: () { Navigator.pop(context); context.go('/contact'); }),
            const Divider(height: 1),
            _DrawerLink(icon: Icons.favorite_border, label: 'Wishlist', onTap: () { Navigator.pop(context); context.go('/wishlist'); }),
            _DrawerLink(icon: Icons.shopping_bag_outlined, label: 'Cart', onTap: () { Navigator.pop(context); context.go('/cart'); }),
            _DrawerLink(icon: Icons.person_outline, label: 'Profile', onTap: () { Navigator.pop(context); context.go('/profile'); }),
            const Spacer(),
            const Divider(height: 1),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SocialIcon(icon: Icons.chat_bubble_outline, url: AppConstants.whatsappUrl),
                  _SocialIcon(icon: Icons.camera_alt_outlined, url: AppConstants.instagramUrl),
                  _SocialIcon(icon: Icons.facebook_outlined, url: AppConstants.facebookUrl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerLink({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.text),
      title: Text(label, style: AppTypography.navLink.copyWith(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;
  const _SocialIcon({required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.crimson),
      onPressed: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}
