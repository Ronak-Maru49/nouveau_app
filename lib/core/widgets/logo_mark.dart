import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The Nouveau™ diamond/flower emblem. Mirrors component `p.A` (module
/// 7870) which renders `/nouveau-logo.png`. Falls back to a vector mark
/// if the raster asset isn't bundled, keeping Phase 1 runnable without
/// requiring the (very large, 1.9MB) source PNG to be re-exported first.
class LogoMark extends StatelessWidget {
  final double size;
  const LogoMark({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.3,
      child: Image.asset(
        'assets/images/nouveau_logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _FallbackMark(size: size),
      ),
    );
  }
}

class _FallbackMark extends StatelessWidget {
  final double size;
  const _FallbackMark({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DiamondBloomPainter(),
    );
  }
}

class _DiamondBloomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.gold, AppColors.goldDark],
      ).createShader(Rect.fromCircle(center: center, radius: r));

    for (var i = 0; i < 4; i++) {
      final angle = (i * 90) * 3.1415926535 / 180;
      final petalCenter = Offset(
        center.dx + r * 0.5 * math.cos(angle),
        center.dy + r * 0.5 * math.sin(angle),
      );
      canvas.drawCircle(petalCenter, r * 0.42, paint);
    }
    canvas.drawCircle(center, r * 0.32, Paint()..color = AppColors.crimson);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Ornamental divider used between section eyebrow/title and the section
/// body — a horizontal line / gold star / horizontal line. Mirrors
/// component `f.A` (module 2452) from the bundle.
class SectionDivider extends StatelessWidget {
  final Color color;
  const SectionDivider({super.key, this.color = AppColors.gold});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0), color.withValues(alpha: 0.4)],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.auto_awesome, size: 18, color: color.withValues(alpha: 0.85)),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.4), color.withValues(alpha: 0)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
