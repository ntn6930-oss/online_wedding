import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/features/e_card/domain/entities/template_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/list_templates_use_case.dart';
import 'package:online_wedding/features/e_card/presentation/pages/template_library_page.dart';
import 'package:online_wedding/core/localization/localization.dart';
import 'package:online_wedding/core/analytics/analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_wedding/features/e_card/domain/usecases/create_new_card_use_case.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController c;
  late Animation<double> wobble;
  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    wobble = Tween(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: c, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    return Scaffold(
      body: Stack(
        children: [
          _AnimatedGradient(controller: c),
          AnimatedBuilder(
            animation: wobble,
            builder: (_, __) => Transform.translate(
              offset: Offset(0, wobble.value),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Text(
                    t('homepage.title'),
                    style: style.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            right: 16,
            top: 16,
            child: _LanguageSwitcher(),
          ),
          Align(
            alignment: Alignment.center,
            child: _HeroCard(controller: c),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child: SizedBox(
                width: 1000,
                child: _IntroAndCarousel(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CTAButton(
                    label: t('homepage.cta.templates'),
                    onTap: () => Navigator.of(context).pushNamed('/templates'),
                  ),
                  const SizedBox(width: 12),
                  _CTAButton(
                    label: t('homepage.cta.my_cards'),
                    onTap: () => Navigator.of(context).pushNamed('/my-cards'),
                  ),
                  const SizedBox(width: 12),
                  _CTAButton(
                    label: t('homepage.cta.sign_in'),
                    onTap: () => Navigator.of(context).pushNamed('/auth'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedGradient extends StatelessWidget {
  final AnimationController controller;
  const _AnimatedGradient({required this.controller});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        final c1 = Color.lerp(const Color(0xFF8E2DE2), const Color(0xFF4A00E0), t)!
            .withOpacity(0.9);
        final c2 = Color.lerp(const Color(0xFFFF758C), const Color(0xFFFF7EB3), 1 - t)!
            .withOpacity(0.9);
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c1, c2],
            ),
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatefulWidget {
  final AnimationController controller;
  const _HeroCard({required this.controller});
  @override
  State<_HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<_HeroCard> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final items = const [
      _HeroSlide('Modern Aura', 'Hiệu ứng mượt mà, hiện đại'),
      _HeroSlide('Classic Rose', 'Lãng mạn, tinh tế, cổ điển'),
      _HeroSlide('Minimal Bliss', 'Tối giản, sang trọng, tinh khiết'),
    ];
    return MouseRegion(
      onHover: (_) => setState(() {}),
      child: GestureDetector(
        onTap: () => setState(() => index = (index + 1) % items.length),
        child: AnimatedScale(
          scale: 1.0 + (widget.controller.value * 0.02),
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 800),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: items[index],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSlide extends StatelessWidget {
  final String title;
  final String desc;
  const _HeroSlide(this.title, this.desc);
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Column(
      key: ValueKey(title),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: style.headlineMedium?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          desc,
          style: style.bodyLarge?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _CTAButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _CTAButton({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }
}

final _templatesProvider = FutureProvider<List<TemplateEntity>>((ref) async {
  final use = ref.read(listTemplatesUseCaseProvider);
  final res = await use.call(null);
  return res.fold((l) => [], (r) => r);
});

class _IntroAndCarousel extends ConsumerStatefulWidget {
  const _IntroAndCarousel();
  @override
  ConsumerState<_IntroAndCarousel> createState() => _IntroAndCarouselState();
}

class _IntroAndCarouselState extends ConsumerState<_IntroAndCarousel> {
  late PageController pc;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    pc = PageController(viewportFraction: 0.75);
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!pc.hasClients) return;
      final next = ((pc.page ?? 0).round() + 1);
      pc.animateToPage(
        next % 5,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }
  @override
  void dispose() {
    pc.dispose();
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    final items = ref.watch(_templatesProvider);
    return items.when(
      data: (list) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            t('intro.line'),
            style: style.titleMedium?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: pc,
              itemCount: list.length,
              itemBuilder: (_, i) => _ParallaxItem(item: list[i], pc: pc, index: i),
            ),
          ),
        ],
      ),
      loading: () => const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _ParallaxItem extends ConsumerWidget {
  final TemplateEntity item;
  final PageController pc;
  final int index;
  const _ParallaxItem({required this.item, required this.pc, required this.index});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    return AnimatedBuilder(
      animation: pc,
      builder: (_, __) {
        double page = 0;
        if (pc.hasClients && pc.page != null) {
          page = pc.page!;
        }
        final delta = (page - index);
        final shift = -30 * delta;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Transform.translate(
                  offset: Offset(shift, 0),
                  child: Image.network(
                    item.previewUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.black45,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white),
                        ),
                        Text(
                          item.category,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: ElevatedButton(
                    onPressed: () {
                      logEvent('view_template', {'templateId': item.templateId});
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TemplateLibraryPage(
                            initialTemplateId: item.templateId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: Text(t('carousel.see_details')),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                      if (uid.isEmpty) {
                        Navigator.of(context).pushNamed('/auth');
                        return;
                      }
                      logEvent('use_template', {'templateId': item.templateId});
                      final use = ref.read(createNewCardUseCaseProvider);
                      final res = await use.call(CreateNewCardParams(
                        templateId: item.templateId,
                        coupleName: 'Your Names',
                        date: DateTime.now().add(const Duration(days: 30)),
                        isPremium: false,
                      ));
                      res.fold((l) {}, (card) {
                        Navigator.of(context).pushNamed('/design/${card.cardId}');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text('Use this template'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LanguageSwitcher extends ConsumerWidget {
  const _LanguageSwitcher();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(langProvider);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () async {
              ref.read(langProvider.notifier).state = AppLang.en;
              await logEvent('language_changed', {'lang': 'en'});
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null && uid.isNotEmpty) {
                try {
                  await FirebaseFirestore.instance.collection('users').doc(uid).set({'lang': 'en'}, SetOptions(merge: true));
                } catch (_) {}
              }
            },
            child: Text(
              'EN',
              style: TextStyle(color: lang == AppLang.en ? Colors.white : Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () async {
              ref.read(langProvider.notifier).state = AppLang.vi;
              await logEvent('language_changed', {'lang': 'vi'});
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null && uid.isNotEmpty) {
                try {
                  await FirebaseFirestore.instance.collection('users').doc(uid).set({'lang': 'vi'}, SetOptions(merge: true));
                } catch (_) {}
              }
            },
            child: Text(
              'VI',
              style: TextStyle(color: lang == AppLang.vi ? Colors.white : Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

