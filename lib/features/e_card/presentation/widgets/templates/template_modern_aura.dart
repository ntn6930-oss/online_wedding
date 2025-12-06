import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/presentation/widgets/wedding_template_wrapper.dart';

class ModernAuraTemplate extends StatefulWidget {
  final WeddingCardEntity card;
  final CardCustomizationEntity? customization;
  final List<String> images;
  const ModernAuraTemplate({
    super.key,
    required this.card,
    this.customization,
    this.images = const [],
  });
  @override
  State<ModernAuraTemplate> createState() => _ModernAuraTemplateState();
}

class _ModernAuraTemplateState extends State<ModernAuraTemplate>
    with SingleTickerProviderStateMixin {
  late AnimationController c;
  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = _hex(widget.customization?.primaryColorHex ?? '#8E2DE2');
    final accent = base.withOpacity(0.6);
    final style = Theme.of(context).textTheme;
    TextStyle apply(TextStyle? s) {
      final f = widget.customization?.font;
      if (f != null && f.isNotEmpty) {
        return GoogleFonts.getFont(f, textStyle: s);
      }
      return s ?? const TextStyle();
    }
    return AnimatedBuilder(
      animation: c,
      builder: (_, __) {
        final t = c.value;
        final a1 = Alignment(-1 + t, -1);
        final a2 = Alignment(1 - t, 1);
        return Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 700),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(blurRadius: 24, color: Colors.black26),
              ],
              gradient: LinearGradient(
                begin: a1,
                end: a2,
                colors: [
                  Color.lerp(base, accent, t)!,
                  Color.lerp(accent, base, t)!,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSlide(
                    offset: Offset(0, 0.2 - t * 0.2),
                    duration: const Duration(milliseconds: 600),
                    child: AnimatedOpacity(
                      opacity: 0.6 + t * 0.4,
                      duration: const Duration(milliseconds: 600),
                      child: WeddingTemplateWrapper(
                        card: widget.card,
                        customization: widget.customization,
                        images: widget.images,
                        brideName: _pair(widget.card.coupleName).$1,
                        groomName: _pair(widget.card.coupleName).$2,
                        bridePhotoUrl: widget.images.isNotEmpty
                            ? widget.images.first
                            : null,
                        groomPhotoUrl: widget.images.length > 1
                            ? widget.images[1]
                            : null,
                        enableRsvp: widget.card.isPremium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _hex(String h) {
    final s = h.replaceAll('#', '');
    return Color(int.parse('FF$s', radix: 16));
  }

  (String?, String?) _pair(String s) {
    final seps = [' & ', ' và ', ' - '];
    for (final sp in seps) {
      if (s.contains(sp)) {
        final parts = s.split(sp);
        if (parts.length == 2) {
          return (parts[0].trim(), parts[1].trim());
        }
      }
    }
    return (null, null);
  }
}

class _ImageStrip extends StatefulWidget {
  final List<String> images;
  const _ImageStrip({required this.images});
  @override
  State<_ImageStrip> createState() => _ImageStripState();
}

class _ImageStripState extends State<_ImageStrip>
    with SingleTickerProviderStateMixin {
  late AnimationController c;
  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 100,
      child: AnimatedBuilder(
        animation: c,
        builder: (_, __) {
          final t = c.value;
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final s = 0.9 + (0.1 * ((i % 3) == 0 ? t : 1 - t));
              return AnimatedScale(
                scale: s,
                duration: const Duration(milliseconds: 400),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(widget.images[i], width: 140, height: 100, fit: BoxFit.cover),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
