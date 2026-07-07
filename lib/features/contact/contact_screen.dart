import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_navbar.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppNavBar(
        onMenuTap: () {},
        onSearchTap: () {},
        onWishlistTap: () {},
        onCartTap: () {},
        onProfileTap: () {},
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Get in Touch', style: AppTypography.sectionTitle(28)),
          const SizedBox(height: 24),
          _ContactTile(
            icon: Icons.chat_bubble_outline,
            title: 'WhatsApp',
            subtitle: AppConstants.whatsappNumber,
            onTap: () => _launch(AppConstants.whatsappUrl),
          ),
          _ContactTile(
            icon: Icons.mail_outline,
            title: 'Email',
            subtitle: AppConstants.contactEmail,
            onTap: () => _launch('mailto:${AppConstants.contactEmail}'),
          ),
          _ContactTile(
            icon: Icons.camera_alt_outlined,
            title: 'Instagram',
            subtitle: '@nouveauzon',
            onTap: () => _launch(AppConstants.instagramUrl),
          ),
          _ContactTile(
            icon: Icons.facebook_outlined,
            title: 'Facebook',
            subtitle: 'Nouveau™',
            onTap: () => _launch(AppConstants.facebookUrl),
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

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.accent,
          child: Icon(icon, color: AppColors.crimson),
        ),
        title: Text(title, style: AppTypography.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTypography.poppins(fontSize: 13, color: AppColors.textMuted)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
      ),
    );
  }
}
