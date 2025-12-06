import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/get_card_by_id_use_case.dart';
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_wedding/core/localization/localization.dart';
import 'package:online_wedding/features/e_card/presentation/widgets/template_factory.dart';
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
    return AnimatedOpacity(
      opacity: show ? 1 : 0,
      duration: const Duration(milliseconds: 600),
      child: TemplateFactory.build(
        widget.card.templateId,
        widget.card,
        widget.customization,
        widget.images,
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

class _Countdown extends ConsumerStatefulWidget {
  final DateTime target;
  final TextStyle style;
  const _Countdown({required this.target, required this.style});
  @override
  ConsumerState<_Countdown> createState() => _CountdownState();
}

class _CountdownState extends ConsumerState<_Countdown> {
  late Duration remaining;
  @override
  void initState() {
    super.initState();
    remaining = widget.target.difference(DateTime.now());
  }
  @override
  Widget build(BuildContext context) {
    final t = ref.watch(tProvider);
    String fmt(Duration d) {
      final days = d.inDays;
      final hours = d.inHours % 24;
      final mins = d.inMinutes % 60;
      return '$days ${t('countdown.days')} • $hours ${t('countdown.hours')} • $mins ${t('countdown.minutes')}';
    }
    return Text(fmt(remaining), style: widget.style);
  }
}

Color _parseHex(String hex) {
  final h = hex.replaceAll('#', '');
  final v = int.parse('FF$h', radix: 16);
  return Color(v);
}
