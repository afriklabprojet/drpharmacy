import 'package:flutter/material.dart';
import '../../domain/models/promo_item.dart';

/// Slider horizontal pour les promotions de la page d'accueil
class PromoSlider extends StatelessWidget {
  final List<PromoItem> items;
  final PageController controller;
  final int currentIndex;
  final bool isDark;
  final ValueChanged<int>? onPageChanged;

  const PromoSlider({
    super.key,
    required this.items,
    required this.controller,
    required this.currentIndex,
    this.isDark = false,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: controller,
            itemCount: items.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _PromoCard(item: item, isDark: isDark),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: index == currentIndex ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == currentIndex
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  final PromoItem item;
  final bool isDark;

  const _PromoCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final colors = item.gradientColorValues;
    final gradient = colors != null && colors.length >= 2
        ? LinearGradient(
            colors: colors.map((c) => Color(c)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item.badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (item.badge != null) const SizedBox(height: 8),
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (item.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              item.subtitle!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
