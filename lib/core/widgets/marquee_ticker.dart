import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Infinite scrolling ticker matching the `@keyframes marquee` crimson
/// strip beneath the hero. Uses a single AnimationController driving a
/// duplicated row for a seamless loop (mirrors the CSS `translateX(-50%)`
/// approach with `Array(4).fill([...]).flat()`).
class MarqueeTicker extends StatefulWidget {
  const MarqueeTicker({super.key});

  @override
  State<MarqueeTicker> createState() => _MarqueeTickerState();
}

class _MarqueeTickerState extends State<MarqueeTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..addListener(_tick);
    _controller.repeat();
  }

  void _tick() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    if (max <= 0) return;
    final offset = _controller.value * max;
    _scrollController.jumpTo(offset);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      4,
      (_) => AppConstants.marqueeItems,
    ).expand((e) => e).toList();

    return Container(
      color: AppColors.crimson,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: items
              .map(
                (label) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: AppTypography.poppins(
                          fontSize: 11,
                          letterSpacing: 4,
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, size: 12, color: AppColors.gold),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
