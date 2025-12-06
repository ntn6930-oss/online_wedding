import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/get_card_by_id_use_case.dart';
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/usecases/create_new_card_use_case.dart';

class PublicCardPage extends ConsumerWidget {
  final String coupleName;
  final String cardId;
  const PublicCardPage({super.key, required this.coupleName, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_cardProvider(cardId));
    return Scaffold(
      appBar: AppBar(title: Text('$coupleName Invitation')),
      body: _PublicCardBody(state: state),
    );
  }
}

final _cardProvider = FutureProvider.family<WeddingCardEntity, String>((ref, id) async {
  final usecase = ref.read(getCardByIdUseCaseProvider);
  final res = await usecase.call(GetCardByIdParams(id));
  return res.fold((l) => throw l, (r) => r);
});

class _PublicCardBody extends ConsumerWidget {
  final AsyncValue<WeddingCardEntity> state;
  const _PublicCardBody({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return state.when(
      data: (card) {
        final custom = ref.watch(_customProvider(card.cardId));
        final images = ref.watch(_imagesProvider(card.cardId));
        return _AnimatedTemplate(
          card: card,
          customization: custom.maybeWhen(data: (v) => v, orElse: () => null),
          images: images.maybeWhen(data: (v) => v, orElse: () => const []),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Not found')),
    );
  }
}

class _AnimatedTemplate extends StatefulWidget {
  final WeddingCardEntity card;
  final CardCustomizationEntity? customization;
  final List<String> images;
  const _AnimatedTemplate({required this.card, this.customization, this.images = const []});

  @override
  State<_AnimatedTemplate> createState() => _AnimatedTemplateState();
}

class _AnimatedTemplateState extends State<_AnimatedTemplate> {
  bool show = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => show = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: show ? 1 : 0,
        duration: const Duration(milliseconds: 600),
        child: _CardContent(
          card: widget.card,
          customization: widget.customization,
          images: widget.images,
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final WeddingCardEntity card;
  final CardCustomizationEntity? customization;
  final List<String> images;
  const _CardContent({required this.card, this.customization, this.images = const []});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final color = _parseHex(customization?.primaryColorHex ?? '#8E2DE2');
    TextStyle apply(TextStyle? base) {
      final f = customization?.font;
      if (f != null && f.isNotEmpty) {
        return GoogleFonts.getFont(f, textStyle: base);
      }
      return base ?? const TextStyle();
    }
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 600),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(card.coupleName, style: apply(style.headlineMedium?.copyWith(color: Colors.white))),
          const SizedBox(height: 8),
          Text(card.date.toIso8601String(), style: apply(style.bodyMedium?.copyWith(color: Colors.white70))),
          const SizedBox(height: 16),
          Text('Template: ${card.templateId}', style: apply(style.bodyMedium?.copyWith(color: Colors.white))),
          const SizedBox(height: 8),
          Text('Card ID: ${card.cardId}', style: apply(style.bodySmall?.copyWith(color: Colors.white70))),
          if (customization?.showCountdown ?? false) ...[
            const SizedBox(height: 16),
            _Countdown(target: card.date, style: apply(style.titleMedium?.copyWith(color: Colors.white))),
          ],
          if (customization?.showMap ?? false) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final q = Uri.encodeComponent(card.coupleName);
                final url = 'https://www.google.com/maps/search/?api=1&query=$q';
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(), body: Center(child: Text(url)))));
              },
              child: const Text('Xem bản đồ'),
            ),
          ],
          if ((customization?.showAlbum ?? false) && images.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Album ảnh', style: apply(style.titleMedium?.copyWith(color: Colors.white))),
            const SizedBox(height: 8),
            _AlbumGrid(images: images),
          ],
        ],
      ),
    );
  }
}

final _customProvider = FutureProvider.family<CardCustomizationEntity?, String>((ref, id) async {
  final repo = ref.read(eCardRepositoryProvider);
  final res = await repo.getCustomization(id);
  return res.fold((l) => null, (r) => r);
});

final _imagesProvider = FutureProvider.family<List<String>, String>((ref, id) async {
  final repo = ref.read(eCardRepositoryProvider);
  final res = await repo.listImages(id);
  return res.fold((l) => [], (r) => r);
});

class _AlbumGrid extends StatelessWidget {
  final List<String> images;
  const _AlbumGrid({required this.images});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (_, i) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(images[i], fit: BoxFit.cover),
      ),
    );
  }
}

class _Countdown extends StatefulWidget {
  final DateTime target;
  final TextStyle style;
  const _Countdown({required this.target, required this.style});
  @override
  State<_Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<_Countdown> {
  late Duration remaining;
  @override
  void initState() {
    super.initState();
    remaining = widget.target.difference(DateTime.now());
  }
  @override
  Widget build(BuildContext context) {
    String fmt(Duration d) {
      final days = d.inDays;
      final hours = d.inHours % 24;
      final mins = d.inMinutes % 60;
      return '$days ngày • $hours giờ • $mins phút';
    }
    return Text(fmt(remaining), style: widget.style);
  }
}

Color _parseHex(String hex) {
  final h = hex.replaceAll('#', '');
  final v = int.parse('FF$h', radix: 16);
  return Color(v);
}

