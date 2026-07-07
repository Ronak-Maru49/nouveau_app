import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'logo_mark.dart';

/// Footer matching the crimson footer block from the site: centered
/// logo/wordmark/tagline, 4-column link grid (stacked on mobile), and a
/// bottom row with copyright + "Made with ♥ in India".
class AppFooter extends StatelessWidget {
  final void Function(String page)? onNavigate;

  const AppFooter({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.footerBg,
      padding: const EdgeInsets.fromLTRB(20, 42, 20, 24),
      child: Column(
        children: [
          // Logo block
          Column(
            children: [
              const LogoMark(size: 40),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: AppTypography.playfair(
                    fontSize: 22,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                  children: const [
                    TextSpan(text: 'nouveau'),
                    TextSpan(
                      text: '™',
                      style: TextStyle(color: AppColors.footerAccent, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppConstants.brandTagline.toUpperCase(),
                style: AppTypography.poppins(
                  fontSize: 8,
                  letterSpacing: 5,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
          const SizedBox(height: 28),

          // About + social
          Text(
            AppConstants.aboutBlurb,
            textAlign: TextAlign.center,
            style: AppTypography.poppins(
              fontSize: 13,
              height: 1.65,
              color: Colors.white.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 18,
            runSpacing: 8,
            children: [
              _FooterLinkButton(
                icon: Icons.chat_bubble_outline,
                label: 'WhatsApp',
                onTap: () => _launch(AppConstants.whatsappUrl),
              ),
              _FooterLinkButton(
                icon: Icons.mail_outline,
                label: 'Email',
                onTap: () => _launch('mailto:${AppConstants.contactEmail}'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          _FooterColumn(
            title: 'Quick Links',
            items: const [
              ('Home', 'Home'),
              ('Shop', 'Shop'),
              ('Indian Ethnic Wear', 'EthnicWear'),
              ('Premium Western Wear', 'WesternWear'),
              ('About Us', 'About'),
              ('Contact', 'Contact'),
            ],
            onTap: (page) => onNavigate?.call(page),
          ),
          const SizedBox(height: 24),
          _FooterColumn(
            title: 'Customer',
            items: const [
              ('Size Guide', 'SizeGuide'),
              ('Shipping Information', 'Shipping'),
              ('Track Order', 'TrackOrder'),
              ('FAQ', 'FAQ'),
            ],
            onTap: (page) => onNavigate?.call(page),
          ),
          const SizedBox(height: 24),
          _FooterColumn(
            title: 'Connect',
            items: const [
              ('Instagram', AppConstants.instagramUrl),
              ('Facebook', AppConstants.facebookUrl),
              ('WhatsApp', AppConstants.whatsappUrl),
            ],
            onTap: (href) => _launch(href),
          ),

          const SizedBox(height: 32),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
          const SizedBox(height: 20),

          Text(
            AppConstants.copyright,
            textAlign: TextAlign.center,
            style: AppTypography.poppins(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppConstants.madeWith,
            textAlign: TextAlign.center,
            style: AppTypography.poppins(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _FooterLinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FooterLinkButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.8)),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.poppins(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<(String, String)> items;
  final ValueChanged<String> onTap;

  const _FooterColumn({required this.title, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title.toUpperCase(), style: AppTypography.footerHeading),
        const SizedBox(height: 14),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onTap(item.$2),
              child: Text(item.$1, style: AppTypography.footerLink),
            ),
          ),
        ),
      ],
    );
  }
}
