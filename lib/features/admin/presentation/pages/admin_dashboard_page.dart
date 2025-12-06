import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/features/e_card/domain/entities/guest_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/guests_use_cases.dart';
import 'package:online_wedding/features/e_card/domain/usecases/get_card_by_id_use_case.dart';
import 'package:online_wedding/features/e_card/domain/usecases/register_slug_use_case.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../e_card/domain/usecases/create_new_card_use_case.dart';

class AdminDashboardPage extends ConsumerWidget {
  final String cardId;
  const AdminDashboardPage({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Invitation'),
          bottom: const TabBar(tabs: [
            Tab(text: 'Guests'),
            Tab(text: 'Gifts'),
            Tab(text: 'Messages'),
          ]),
        ),
        body: TabBarView(children: [
          GuestsTab(cardId: cardId),
          PublishTab(cardId: cardId),
          const _PlaceholderTab(label: 'Messages'),
        ]),
      ),
    );
  }
}

class GuestsTab extends ConsumerWidget {
  final String cardId;
  const GuestsTab({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guests = ref.watch(_guestsProvider(cardId));
    return Column(
      children: [
        Expanded(child: _GuestsList(state: guests)),
        _AddGuestForm(cardId: cardId),
      ],
    );
  }
}

final _guestsProvider = FutureProvider.family<List<GuestEntity>, String>((ref, id) async {
  final usecase = ref.read(listGuestsUseCaseProvider);
  final res = await usecase.call(ListGuestsParams(id));
  return res.fold((l) => [], (r) => r);
});

class _GuestsList extends StatelessWidget {
  final AsyncValue<List<GuestEntity>> state;
  const _GuestsList({required this.state});
  @override
  Widget build(BuildContext context) {
    return state.when(
      data: (list) => ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, i) {
          final g = list[i];
          return ListTile(
            title: Text(g.name),
            subtitle: Text('Invited: ${g.invited} • Attended: ${g.attended}'),
            trailing: Text(g.giftAmount.toStringAsFixed(2)),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _AddGuestForm extends ConsumerStatefulWidget {
  final String cardId;
  const _AddGuestForm({required this.cardId});
  @override
  ConsumerState<_AddGuestForm> createState() => _AddGuestFormState();
}

class _AddGuestFormState extends ConsumerState<_AddGuestForm> {
  final _nameCtrl = TextEditingController();
  bool _invited = true;
  bool _attended = false;
  double _gift = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Guest name')),
          Row(children: [
            Expanded(child: SwitchListTile(title: const Text('Invited'), value: _invited, onChanged: (v){setState(()=>_invited=v);})),
            Expanded(child: SwitchListTile(title: const Text('Attended'), value: _attended, onChanged: (v){setState(()=>_attended=v);})),
          ]),
          Row(children: [
            Expanded(child: TextField(keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gift amount'), onChanged: (v){_gift = double.tryParse(v)??0;})),
            ElevatedButton(onPressed: _addGuest, child: const Text('Add')),
          ]),
        ],
      ),
    );
  }

  void _addGuest() async {
    final guest = GuestEntity(
      guestId: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      invited: _invited,
      attended: _attended,
      giftAmount: _gift,
    );
    final usecase = ref.read(addGuestUseCaseProvider);
    await usecase.call(AddGuestParams(cardId: widget.cardId, guest: guest));
    ref.refresh(_guestsProvider(widget.cardId));
    _nameCtrl.clear();
    setState((){_invited=true;_attended=false;_gift=0;});
  }
}

class PublishTab extends ConsumerWidget {
  final String cardId;
  const PublishTab({super.key, required this.cardId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardState = ref.watch(_cardProvider(cardId));
    final isPublicState = ref.watch(_publicProvider(cardId));
    return cardState.when(
      data: (card) {
        final slugCtrl = TextEditingController();
        final urlById = '/${card.coupleName}/$card.cardId';
        final currentPublic = isPublicState.maybeWhen(data: (v) => v, orElse: () => false);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text('Công khai'),
                const SizedBox(width: 12),
                Switch(
                  value: currentPublic,
                  onChanged: (v) async {
                    await ref.read(eCardRepositoryProvider).setPublicStatus(cardId, v);
                    ref.refresh(_publicProvider(cardId));
                  },
                ),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: slugCtrl,
                    decoration: const InputDecoration(labelText: 'Slug cặp đôi'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final slug = slugCtrl.text.trim();
                    if (slug.isNotEmpty) {
                      await ref.read(registerSlugUseCaseProvider).call(RegisterSlugParams(slug: slug, cardId: cardId));
                    }
                  },
                  child: const Text('Lưu slug'),
                ),
              ]),
              const SizedBox(height: 16),
              Text('QR theo đường dẫn mặc định'),
              const SizedBox(height: 8),
              QrImageView(data: urlById, size: 160),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

final _cardProvider = FutureProvider.family((ref, String id) async {
  final uc = ref.read(getCardByIdUseCaseProvider);
  final res = await uc.call(GetCardByIdParams(id));
  return res.fold((l) => throw l, (r) => r);
});

final _publicProvider = FutureProvider.family<bool, String>((ref, id) async {
  final repo = ref.read(eCardRepositoryProvider);
  final res = await repo.getPublicStatus(id);
  return res.fold((l) => false, (r) => r);
});

class _PlaceholderTab extends StatelessWidget {
  final String label;
  const _PlaceholderTab({required this.label});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(label));
  }
}
