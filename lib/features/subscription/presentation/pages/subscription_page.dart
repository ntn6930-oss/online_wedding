import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_wedding/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:online_wedding/core/localization/localization.dart';
import 'package:cloud_functions/cloud_functions.dart';

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
    final t = ref.watch(tProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t('subscription.title'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            sub.when(
              data: (s) => s == null
                  ? Text('${t('subscription.current_plan')}: -')
                  : Text('${t('subscription.current_plan')}: ${s.planId}'),
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
                                  final callable = FirebaseFunctions.instance.httpsCallable('createCheckoutSession');
                                  final res = await callable.call({'planId': p.planId});
                                  final url = (res.data ?? {})['sessionUrl'] ?? '';
                                  if (url is String && url.isNotEmpty) {
                                    Navigator.of(context).pushNamed('/checkout', arguments: {'url': url});
                                  }
                                },
                                child: Text(t('subscription.choose')),
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
            Text(t('subscription.recent_invoices')),
            invoices.when(
              data: (list) => Column(
                children: list
                    .map(
                      (iv) => ListTile(
                        title: Text('${t('subscription.amount')}: ${iv.amount}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${t('subscription.note')}: ${iv.note}'),
                            if (iv.status != null) Text('${t('invoice.status')}: ${iv.status}'),
                            if (iv.transactionId != null && iv.transactionId!.isNotEmpty)
                              Text('${t('invoice.txid')}: ${iv.transactionId}'),
                          ],
                        ),
                        trailing: Text('${t('subscription.date')}: ${iv.createdAt.toIso8601String()}'),
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
