import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_wedding/features/subscription/domain/repositories/subscription_repository.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) => throw UnimplementedError());

final _authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final _plansProvider = FutureProvider<List<SubscriptionPlan>>((ref) async {
  final repo = ref.read(subscriptionRepositoryProvider);
  final res = await repo.listPlans();
  return res.fold((l) => [], (r) => r);
});
final _subProvider = FutureProvider<UserSubscription?>((ref) async {
  final repo = ref.read(subscriptionRepositoryProvider);
  final uid = ref.read(_authProvider).currentUser?.uid ?? '';
  if (uid.isEmpty) return null;
  final res = await repo.getUserSubscription(uid);
  return res.fold((l) => null, (r) => r);
});
final _invoicesProvider = FutureProvider<List<InvoiceItem>>((ref) async {
  final repo = ref.read(subscriptionRepositoryProvider);
  final uid = ref.read(_authProvider).currentUser?.uid ?? '';
  if (uid.isEmpty) return [];
  final res = await repo.listInvoices(uid, limit: 20);
  return res.fold((l) => [], (r) => r);
});

class SubscriptionPage extends ConsumerWidget {
  const SubscriptionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(_plansProvider);
    final sub = ref.watch(_subProvider);
    final invoices = ref.watch(_invoicesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Gói dịch vụ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            sub.when(
              data: (s) => s == null
                  ? const Text('Chưa đăng nhập hoặc chưa chọn gói')
                  : Text('Gói hiện tại: ${s.planId}'),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            plans.when(
              data: (list) => Column(
                children: list
                    .map(
                      (p) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.name, style: Theme.of(context).textTheme.titleMedium),
                                    Text('${p.price}/${p.period}'),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final uid = ref.read(_authProvider).currentUser?.uid ?? '';
                                  if (uid.isEmpty) return;
                                  await ref.read(subscriptionRepositoryProvider).setUserPlan(uid, p.planId);
                                  ref.refresh(_subProvider);
                                },
                                child: const Text('Chọn gói'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            const Text('Hóa đơn gần đây'),
            invoices.when(
              data: (list) => Column(
                children: list
                    .map(
                      (iv) => ListTile(
                        title: Text('${iv.amount}'),
                        subtitle: Text(iv.note),
                        trailing: Text(iv.createdAt.toIso8601String()),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
