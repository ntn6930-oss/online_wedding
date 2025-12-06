import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/presentation/widgets/wedding_template_wrapper.dart';

class MinimalBlissTemplate extends StatefulWidget {
  final WeddingCardEntity card;
  final CardCustomizationEntity? customization;
  final List<String> images;
  const MinimalBlissTemplate({
    super.key,
    required this.card,
    this.customization,
    this.images = const [],
  });
  @override
  State<MinimalBlissTemplate> createState() => _MinimalBlissTemplateState();
}

class _MinimalBlissTemplateState extends State<MinimalBlissTemplate>
    with SingleTickerProviderStateMixin {
  late AnimationController c;
  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final base = _hex(widget.customization?.primaryColorHex ?? '#2E7D32');
    TextStyle apply(TextStyle? s) {
      final f = widget.customization?.font;
      if (f != null && f.isNotEmpty) {
        return GoogleFonts.getFont(f, textStyle: s);
      }
      return s ?? const TextStyle();
    }
    return Center(
      child: AnimatedScale(
        scale: Tween<double>(begin: 0.95, end: 1).animate(c).value,
        duration: const Duration(milliseconds: 800),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 640),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(blurRadius: 20, color: Colors.black12),
            ],
          ),
          child: WeddingTemplateWrapper(
            card: widget.card,
            customization: widget.customization,
            images: widget.images,
            brideName: _pair(widget.card.coupleName).$1,
            groomName: _pair(widget.card.coupleName).$2,
            bridePhotoUrl:
                widget.images.isNotEmpty ? widget.images.first : null,
            groomPhotoUrl:
                widget.images.length > 1 ? widget.images[1] : null,
            enableRsvp: widget.card.isPremium,
          ),
        ),
      ),
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

class _MinimalAlbum extends StatelessWidget {
  final List<String> images;
  const _MinimalAlbum({required this.images});
  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(images[i], width: 160, fit: BoxFit.cover),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: images.length,
      ),
    );
  }
}
