import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/create_new_card_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';

final templateIdProvider = StateProvider<String>((ref) => '');
final coupleNameProvider = StateProvider<String>((ref) => '');
final dateProvider = StateProvider<DateTime?>((ref) => null);
final isPremiumProvider = StateProvider<bool>((ref) => false);

final createCardControllerProvider = StateNotifierProvider<CreateCardController,
    AsyncValue<WeddingCardEntity?>>((ref) {
  return CreateCardController(ref);
});

class CreateCardController
    extends StateNotifier<AsyncValue<WeddingCardEntity?>> {
  final Ref ref;
  CreateCardController(this.ref) : super(const AsyncValue.data(null));

  Future<void> submit({
    required String templateId,
    required String coupleName,
    required DateTime? date,
    required bool isPremium,
  }) async {
    if (date == null) {
      state = AsyncValue.error('Please select a date', StackTrace.current);
      return;
    }
    state = const AsyncValue.loading();
    final params = CreateNewCardParams(
      templateId: templateId,
      coupleName: coupleName,
      date: date,
      isPremium: isPremium,
    );
    final result = await ref.read(createNewCardUseCaseProvider).call(params);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (card) => AsyncValue.data(card),
    );
  }
}

class CreateCardPage extends ConsumerWidget {
  const CreateCardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templateId = ref.watch(templateIdProvider);
    final coupleName = ref.watch(coupleNameProvider);
    final selectedDate = ref.watch(dateProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final createState = ref.watch(createCardControllerProvider);

    Future<void> pickDate() async {
      final now = DateTime.now();
      final date = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year - 1),
        lastDate: DateTime(now.year + 5),
      );
      if (date != null) {
        ref.read(dateProvider.notifier).state = date;
      }
    }

    void submit() {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng đăng nhập để tạo thiệp')),
        );
        return;
      }
      ref.read(createCardControllerProvider.notifier).submit(
            templateId: templateId,
            coupleName: coupleName,
            date: selectedDate,
            isPremium: isPremium,
          );
    }

    Widget buildResult(AsyncValue<WeddingCardEntity?> state) {
      return state.when(
        data: (card) {
          if (card == null) return const SizedBox.shrink();
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Card ID: ${card.cardId}'),
                  Text('Template: ${card.templateId}'),
                  Text('Couple: ${card.coupleName}'),
                  Text('Date: ${card.date.toIso8601String()}'),
                  Text('Storage URL: ${card.storageUrl}'),
                  Text('Premium: ${card.isPremium}'),
                ],
              ),
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(),
        ),
        error: (err, _) => Padding(
          padding: const EdgeInsets.all(12),
          child: Text('Error: $err'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create New E-Card')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Template ID'),
              onChanged: (v) =>
                  ref.read(templateIdProvider.notifier).state = v.trim(),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Couple Name'),
              onChanged: (v) =>
                  ref.read(coupleNameProvider.notifier).state = v.trim(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'No date selected'
                        : 'Date: ${selectedDate.toIso8601String()}',
                  ),
                ),
                TextButton(
                  onPressed: pickDate,
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Premium'),
              value: isPremium,
              onChanged: (v) => ref.read(isPremiumProvider.notifier).state = v,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submit,
              child: const Text('Create Card'),
            ),
            const SizedBox(height: 16),
            buildResult(createState),
          ],
        ),
      ),
    );
  }
}
