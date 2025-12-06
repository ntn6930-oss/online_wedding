import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_wedding/core/localization/localization.dart';
import 'package:online_wedding/features/subscription/domain/repositories/subscription_repository.dart';

import '../../../subscription/presentation/pages/subscription_page.dart';
final _authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

class AdminControlPanelPage extends ConsumerWidget {
  const AdminControlPanelPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    final isAdmin = ref.watch(_isAdminProvider).maybeWhen(data: (v) => v, orElse: () => false);
    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: Text(t('admin.panel'))),
        body: Center(child: Text(t('admin.locked'))),
      );
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t('admin.panel')),
          bottom: TabBar(tabs: [
            Tab(text: t('admin.plans')),
            Tab(text: t('admin.billing')),
          ]),
        ),
        body: const TabBarView(children: [
          _PlansTab(),
          _BillingTab(),
        ]),
      ),
    );
  }
}

final _plansProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final qs = await FirebaseFirestore.instance.collection('plans').get();
  return qs.docs.map((d) => {'id': d.id, ...d.data()}).toList();
});

final _isAdminProvider = FutureProvider<bool>((ref) async {
  final auth = ref.read(_authProvider);
  final user = auth.currentUser;
  if (user == null) return false;
  final res = await user.getIdTokenResult(true);
  final claims = res.claims ?? {};
  return (claims['admin'] as bool?) ?? false;
});

class _PlansTab extends ConsumerStatefulWidget {
  const _PlansTab();
  @override
  ConsumerState<_PlansTab> createState() => _PlansTabState();
}

class _PlansTabState extends ConsumerState<_PlansTab> {
  final idCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final periodCtrl = TextEditingController(text: 'monthly');
  final currencyCtrl = TextEditingController(text: 'usd');
  final priceIdCtrl = TextEditingController();
  @override
  void dispose() {
    idCtrl.dispose();
    nameCtrl.dispose();
    priceCtrl.dispose();
    periodCtrl.dispose();
    currencyCtrl.dispose();
    priceIdCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final t = ref.watch(tProvider);
    final plans = ref.watch(_plansProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          plans.when(
            data: (list) => Column(
              children: list
                  .map(
                    (p) => ListTile(
                      title: Text('${p['name'] ?? p['id']} • ${p['price'] ?? 0} ${p['currency'] ?? 'usd'}'),
                      subtitle: Text('id=${p['id']} • period=${p['period'] ?? 'monthly'} • priceId=${p['priceId'] ?? '-'}'),
                    ),
                  )
                  .toList(),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          TextField(controller: idCtrl, decoration: InputDecoration(labelText: t('plan.id'))),
          TextField(controller: nameCtrl, decoration: InputDecoration(labelText: t('plan.name'))),
          TextField(controller: priceCtrl, decoration: InputDecoration(labelText: t('plan.price'))),
          TextField(controller: periodCtrl, decoration: InputDecoration(labelText: t('plan.period'))),
          TextField(controller: currencyCtrl, decoration: InputDecoration(labelText: t('plan.currency'))),
          TextField(controller: priceIdCtrl, decoration: InputDecoration(labelText: t('plan.price_id'))),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final id = idCtrl.text.trim();
              if (id.isEmpty) return;
              final name = nameCtrl.text.trim();
              final price = double.tryParse(priceCtrl.text.trim()) ?? 0;
              final period = periodCtrl.text.trim();
              final currency = currencyCtrl.text.trim();
              final priceId = priceIdCtrl.text.trim();
              final callable = FirebaseFunctions.instance.httpsCallable('seedPlans');
              await callable.call({
                'items': [
                  {
                    'planId': id,
                    'name': name,
                    'price': price,
                    'period': period,
                    'currency': currency,
                    if (priceId.isNotEmpty) 'priceId': priceId,
                  }
                ]
              });
              ref.refresh(_plansProvider);
            },
            child: Text(t('plan.save')),
          ),
        ],
      ),
    );
  }
}

final _uidCtrlProvider = StateProvider<String>((ref) => '');
final _invProvider = FutureProvider<List<InvoiceItem>>((ref) async {
  final repo = ref.read(subscriptionRepositoryProvider);
  final uid = ref.watch(_uidCtrlProvider);
  if (uid.isEmpty) return [];
  final res = await repo.listInvoices(uid, limit: 50);
  return res.fold((l) => [], (r) => r);
});
final _subProvider = FutureProvider<UserSubscription?>((ref) async {
  final repo = ref.read(subscriptionRepositoryProvider);
  final uid = ref.watch(_uidCtrlProvider);
  if (uid.isEmpty) return null;
  final res = await repo.getUserSubscription(uid);
  return res.fold((l) => null, (r) => r);
});

class _BillingTab extends ConsumerWidget {
  const _BillingTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    final sub = ref.watch(_subProvider);
    final inv = ref.watch(_invProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: TextField(
                onChanged: (v) => ref.read(_uidCtrlProvider.notifier).state = v.trim(),
                decoration: InputDecoration(labelText: t('billing.owner')),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                final uid = ref.read(_uidCtrlProvider);
                if (uid.isEmpty) return;
                final callable = FirebaseFunctions.instance.httpsCallable('setAdminClaim');
                await callable.call({'uid': uid, 'set': true});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('admin.granted'))));
              },
              child: Text(t('admin.grant')),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                final uid = ref.read(_uidCtrlProvider);
                if (uid.isEmpty) return;
                final callable = FirebaseFunctions.instance.httpsCallable('setAdminClaim');
                await callable.call({'uid': uid, 'set': false});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('admin.revoked'))));
              },
              child: Text(t('admin.revoke')),
            ),
          ]),
          const SizedBox(height: 12),
          sub.when(
            data: (s) => s == null
                ? Text('${t('subscription.current_plan')}: -')
                : Text('${t('subscription.current_plan')}: ${s.planId}'),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: inv.when(
              data: (list) => ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final iv = list[i];
                  return ListTile(
                    title: Text('${t('subscription.amount')}: ${iv.amount}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${t('subscription.note')}: ${iv.note}'),
                        if (iv.status != null)
                          Text('${t('invoice.status')}: ${iv.status}'),
                        if (iv.transactionId != null && iv.transactionId!.isNotEmpty)
                          Text('${t('invoice.txid')}: ${iv.transactionId}'),
                      ],
                    ),
                    trailing: Text(iv.createdAt.toIso8601String()),
                  );
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
