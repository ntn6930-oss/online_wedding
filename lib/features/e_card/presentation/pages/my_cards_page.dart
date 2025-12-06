import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';
import 'package:online_wedding/features/e_card/domain/entities/guest_entity.dart';
import 'package:online_wedding/core/localization/localization.dart';

import '../../domain/usecases/create_new_card_use_case.dart';


final _authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final myCardsControllerProvider = StateNotifierProvider<MyCardsController, AsyncValue<List<WeddingCardEntity>>>((ref) {
  final auth = ref.watch(_authProvider);
  final uid = auth.currentUser?.uid ?? '';
  return MyCardsController(ref, uid);
});

class MyCardsController extends StateNotifier<AsyncValue<List<WeddingCardEntity>>> {
  final Ref ref;
  final String uid;
  DateTime? lastDate;
  int limit;
  MyCardsController(this.ref, this.uid, {this.limit = 20}) : super(const AsyncValue.data([]));
  Future<void> loadInitial() async {
    if (uid.isEmpty) return;
    state = const AsyncValue.loading();
    final repo = ref.read(eCardRepositoryProvider);
    final res = await repo.listCardsByOwnerPaged(uid, limit, null);
    state = res.fold((l) => AsyncValue.error(l, StackTrace.current), (list) {
      if (list.isNotEmpty) {
        lastDate = list.last.date;
      }
      return AsyncValue.data(list);
    });
  }
  Future<void> loadMore() async {
    if (uid.isEmpty) return;
    final repo = ref.read(eCardRepositoryProvider);
    final res = await repo.listCardsByOwnerPaged(uid, limit, lastDate);
    res.fold((l) {}, (more) {
      final current = state.maybeWhen(data: (v) => v, orElse: () => <WeddingCardEntity>[]);
      final next = [...current, ...more];
      if (more.isNotEmpty) {
        lastDate = more.last.date;
      }
      state = AsyncValue.data(next);
    });
  }
}

class MyCardsPage extends ConsumerWidget {
  const MyCardsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(myCardsControllerProvider);
    final t = ref.watch(tProvider);
    ref.read(myCardsControllerProvider.notifier).loadInitial();
    return Scaffold(
      appBar: AppBar(title: Text(t('my_cards.title'))),
      body: cards.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(child: Text('No cards'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _CardManageTile(card: list[i]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${t('common.error')}: $e')),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () => ref.read(myCardsControllerProvider.notifier).loadMore(),
              child: Text(t('common.load_more')),
            ),
            const SizedBox(width: 12),
            DropdownButton<int>(
              value: ref.read(myCardsControllerProvider.notifier).limit,
              items: const [20, 50]
                  .map((l) => DropdownMenuItem<int>(value: l, child: Text('Limit $l')))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  final ctl = ref.read(myCardsControllerProvider.notifier);
                  ctl.limit = v;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CardManageTile extends ConsumerWidget {
  final WeddingCardEntity card;
  const _CardManageTile({required this.card});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(card.coupleName, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('ID: ${card.cardId}'),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/design/${card.cardId}');
                  },
                  child: const Text('Thiết kế'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/admin/${card.cardId}');
                  },
                  child: const Text('Công khai/Slug'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/${card.coupleName}/${card.cardId}');
                  },
                  child: const Text('Xem thiệp'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _GuestsPanel(cardId: card.cardId),
            const SizedBox(height: 8),
            _AlbumPanel(cardId: card.cardId),
          ],
        ),
      ),
    );
  }
}

final guestsControllerProvider = StateNotifierProvider.family<GuestsController, AsyncValue<List<GuestEntity>>, String>((ref, id) {
  return GuestsController(ref, id);
});

class GuestsController extends StateNotifier<AsyncValue<List<GuestEntity>>> {
  final Ref ref;
  final String cardId;
  String? lastGuestId;
  int limit = 20;
  GuestsController(this.ref, this.cardId) : super(const AsyncValue.data([]));
  Future<void> loadInitial() async {
    state = const AsyncValue.loading();
    final repo = ref.read(eCardRepositoryProvider);
    final res = await repo.listGuestsPaged(cardId, limit, null);
    state = res.fold((l) => AsyncValue.error(l, StackTrace.current), (list) {
      if (list.isNotEmpty) lastGuestId = list.last.guestId;
      return AsyncValue.data(list);
    });
  }
  Future<void> loadMore() async {
    final repo = ref.read(eCardRepositoryProvider);
    final res = await repo.listGuestsPaged(cardId, limit, lastGuestId);
    res.fold((l) {}, (more) {
      final current = state.maybeWhen(data: (v) => v, orElse: () => <GuestEntity>[]);
      final next = [...current, ...more];
      if (more.isNotEmpty) lastGuestId = more.last.guestId;
      state = AsyncValue.data(next);
    });
  }
}

class _GuestsPanel extends ConsumerWidget {
  final String cardId;
  const _GuestsPanel({required this.cardId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guests = ref.watch(guestsControllerProvider(cardId));
    final t = ref.watch(tProvider);
    ref.read(guestsControllerProvider(cardId).notifier).loadInitial();
    final nameCtrl = TextEditingController();
    final invitedCtrl = ValueNotifier<bool>(false);
    final attendedCtrl = ValueNotifier<bool>(false);
    final moneyCtrl = TextEditingController();
    return guests.when(
      data: (list) {
        final total = list.fold<double>(0, (p, e) => p + e.giftAmount);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${t('guests.title')} • ${t('guests.total_gift')}: $total'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên'))),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: TextField(controller: moneyCtrl, decoration: const InputDecoration(labelText: 'Quà'), keyboardType: TextInputType.number),
              ),
              const SizedBox(width: 8),
              ValueListenableBuilder<bool>(
                valueListenable: invitedCtrl,
                builder: (_, v, __) => Checkbox(value: v, onChanged: (nv) => invitedCtrl.value = nv ?? false),
              ),
              const Text('Mời'),
              const SizedBox(width: 8),
              ValueListenableBuilder<bool>(
                valueListenable: attendedCtrl,
                builder: (_, v, __) => Checkbox(value: v, onChanged: (nv) => attendedCtrl.value = nv ?? false),
              ),
              const Text('Dự'),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  final repo = ref.read(eCardRepositoryProvider);
                  final g = GuestEntity(
                    guestId: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameCtrl.text.trim(),
                    invited: invitedCtrl.value,
                    attended: attendedCtrl.value,
                    giftAmount: double.tryParse(moneyCtrl.text.trim()) ?? 0,
                  );
                  await repo.addGuest(cardId, g);
                  await ref.read(guestsControllerProvider(cardId).notifier).loadInitial();
                },
                child: Text(t('guests.add')),
              ),
            ]),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (_, i) => Row(
                children: [
                  Expanded(child: Text(list[i].name)),
                  Text('Quà: ${list[i].giftAmount}')
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              ElevatedButton(
                onPressed: () => ref.read(guestsControllerProvider(cardId).notifier).loadMore(),
                child: Text(t('common.load_more')),
              ),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: ref.read(guestsControllerProvider(cardId).notifier).limit,
                items: const [20, 50]
                    .map((l) => DropdownMenuItem<int>(value: l, child: Text('Limit $l')))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    ref.read(guestsControllerProvider(cardId).notifier).limit = v;
                  }
                },
              ),
            ]),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('${t('common.error')} guests: $e'),
    );
  }
}

final _imagesProvider2 = FutureProvider.family<List<String>, String>((ref, id) async {
  final repo = ref.read(eCardRepositoryProvider);
  final res = await repo.listImages(id);
  return res.fold((l) => [], (r) => r);
});

class _AlbumPanel extends ConsumerWidget {
  final String cardId;
  const _AlbumPanel({required this.cardId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(_imagesProvider2(cardId));
    final t = ref.watch(tProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t('album.title')),
        const SizedBox(height: 8),
        Row(children: [
          ElevatedButton(
            onPressed: () async {
              final picker = ImagePicker();
              final file = await picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 85,
                maxWidth: 1280,
              );
              if (file != null) {
                final bytes = await file.readAsBytes();
                final repo = ref.read(eCardRepositoryProvider);
                await repo.uploadImage(cardId, file.name, bytes);
                ref.refresh(_imagesProvider2(cardId));
              }
            },
            child: Text(t('album.upload')),
          ),
        ]),
        const SizedBox(height: 8),
        images.when(
          data: (list) => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: list.length,
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(list[i], fit: BoxFit.cover),
            ),
          ),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('${t('common.error')}: $e'),
        ),
      ],
    );
  }
}
