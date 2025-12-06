import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/presentation/widgets/wedding_template_wrapper.dart';

class ClassicRoseTemplate extends StatefulWidget {
  final WeddingCardEntity card;
  final CardCustomizationEntity? customization;
  final List<String> images;
  const ClassicRoseTemplate({
    super.key,
    required this.card,
    this.customization,
    this.images = const [],
  });
  @override
  State<ClassicRoseTemplate> createState() => _ClassicRoseTemplateState();
}

class _ClassicRoseTemplateState extends State<ClassicRoseTemplate>
    with SingleTickerProviderStateMixin {
  late AnimationController c;
  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final base = _hex(widget.customization?.primaryColorHex ?? '#C2185B');
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
        final r = 16 + 24 * t;
        return Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 680),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [base.withOpacity(0.9), base.withOpacity(0.6)],
                radius: 1.2,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(blurRadius: 30, color: Colors.black26),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: base, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(r),
                          color: base.withOpacity(0.1),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
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
                      const SizedBox(height: 20),
                      _RoseDivider(color: base),
                    ],
                  ),
                ),
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

class _RoseDivider extends StatefulWidget {
  final Color color;
  const _RoseDivider({required this.color});
  @override
  State<_RoseDivider> createState() => _RoseDividerState();
}

class _RoseDividerState extends State<_RoseDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController c;
  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: AnimatedBuilder(
        animation: c,
        builder: (_, __) {
          final t = c.value;
          final w = 160 + 60 * t;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 2, width: w, color: widget.color),
            ],
          );
        },
      ),
    );
  }
}
