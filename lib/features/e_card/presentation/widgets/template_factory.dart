import 'package:flutter/material.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/presentation/widgets/templates/template_modern_aura.dart';
import 'package:online_wedding/features/e_card/presentation/widgets/templates/template_classic_rose.dart';
import 'package:online_wedding/features/e_card/presentation/widgets/templates/template_minimal_bliss.dart';

class TemplateFactory {
  static Widget build(
    String templateId,
    WeddingCardEntity card,
    CardCustomizationEntity? customization,
    List<String> images,
  ) {
    switch (templateId) {
      case 'tpl_modern_01':
        return ModernAuraTemplate(
          card: card,
          customization: customization,
          images: images,
        );
      case 'tpl_classic_01':
        return ClassicRoseTemplate(
          card: card,
          customization: customization,
          images: images,
        );
      case 'tpl_min_01':
        return MinimalBlissTemplate(
          card: card,
          customization: customization,
          images: images,
        );
      default:
        return _Fallback(card: card);
    }
  }
}

class _Fallback extends StatelessWidget {
  final WeddingCardEntity card;
  const _Fallback({required this.card});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.deepPurple,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.coupleName,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              card.date.toIso8601String(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

