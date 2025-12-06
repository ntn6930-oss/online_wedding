import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/get_card_by_slug_use_case.dart';
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';
import 'package:online_wedding/core/web/seo.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/usecases/create_new_card_use_case.dart';

class PublicCardBySlugPage extends ConsumerWidget {
  final String slug;
  const PublicCardBySlugPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_cardBySlugProvider(slug));
    return Scaffold(
      appBar: AppBar(title: Text(slug)),
      body: state.when(
        data: (card) {
          Seo.setMeta(title: card.coupleName, description: 'Thiệp cưới của ${card.coupleName}');
          return _CardBody(card: card);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Không tìm thấy thiệp')),
      ),
    );
  }
}

final _cardBySlugProvider = FutureProvider.family<WeddingCardEntity, String>((ref, slug) async {
  final usecase = ref.read(getCardBySlugUseCaseProvider);
  final res = await usecase.call(GetCardBySlugParams(slug));
  return res.fold((l) => throw l, (r) => r);
});

class _CardBody extends ConsumerWidget {
  final WeddingCardEntity card;
  const _CardBody({required this.card});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;
    final custom = ref.watch(_customProvider(card.cardId));
    final images = ref.watch(_imagesProvider(card.cardId));
    final c = custom.maybeWhen(data: (v) => v, orElse: () => null);
    final list = images.maybeWhen(data: (v) => v, orElse: () => const []);
    final color = _parseHex(c?.primaryColorHex ?? '#8E2DE2');
    TextStyle apply(TextStyle? base) {
      final f = c?.font;
      if (f != null && f.isNotEmpty) {
        return GoogleFonts.getFont(f, textStyle: base);
      }
      return base ?? const TextStyle();
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(card.coupleName, style: apply(style.headlineMedium?.copyWith(color: Colors.white))),
            const SizedBox(height: 8),
            Text(card.date.toIso8601String(), style: apply(style.bodyMedium?.copyWith(color: Colors.white70))),
            const SizedBox(height: 16),
            if (c?.showCountdown ?? false) ...[
              _Countdown(target: card.date, style: apply(style.titleMedium?.copyWith(color: Colors.white))),
              const SizedBox(height: 16),
            ],
            if ((c?.showAlbum ?? false) && list.isNotEmpty) ...[
              Text('Album ảnh', style: style.titleMedium?.copyWith(color: Colors.white, fontFamily: c?.font)),
              const SizedBox(height: 8),
              _AlbumGrid(images: list.cast<String>()),
            ],
          ],
        ),
      ),
    );
  }
}

class _Countdown extends StatelessWidget {
  final DateTime target;
  final TextStyle style;
  const _Countdown({required this.target, required this.style});
  @override
  Widget build(BuildContext context) {
    final d = target.difference(DateTime.now());
    final days = d.inDays;
    final hours = d.inHours % 24;
    final mins = d.inMinutes % 60;
    return Text('$days ngày • $hours giờ • $mins phút', style: style);
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

Color _parseHex(String hex) {
  final h = hex.replaceAll('#', '');
  final v = int.parse('FF$h', radix: 16);
  return Color(v);
}

