import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';

class InvitationHeader extends StatelessWidget {
  final WeddingCardEntity card;
  final CardCustomizationEntity? customization;
  const InvitationHeader({
    super.key,
    required this.card,
    this.customization,
  });
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    TextStyle apply(TextStyle? s) {
      final f = customization?.font;
      if (f != null && f.isNotEmpty) {
        return GoogleFonts.getFont(f, textStyle: s);
      }
      return s ?? const TextStyle();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          card.coupleName,
          style: apply(style.headlineMedium),
        ),
        const SizedBox(height: 8),
        Text(
          card.date.toIso8601String(),
          style: apply(style.bodyMedium?.copyWith(color: Colors.black54)),
        ),
      ],
    );
  }
}

