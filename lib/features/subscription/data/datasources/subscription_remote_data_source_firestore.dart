import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_wedding/features/subscription/domain/repositories/subscription_repository.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<SubscriptionPlan>> listPlans();
  Future<UserSubscription?> getUserSubscription(String ownerUid);
  Future<void> setUserPlan(String ownerUid, String planId);
  Future<void> addInvoice(String ownerUid, double amount, String note);
  Future<List<InvoiceItem>> listInvoices(String ownerUid, {int limit = 20});
}

class FirestoreSubscriptionRemoteDataSource implements SubscriptionRemoteDataSource {
  final FirebaseFirestore db;
  FirestoreSubscriptionRemoteDataSource(this.db);
  @override
  Future<List<SubscriptionPlan>> listPlans() async {
    final qs = await db.collection('plans').get();
    if (qs.docs.isEmpty) {
      return const [
        SubscriptionPlan(planId: 'free', name: 'Free', price: 0, period: 'monthly'),
        SubscriptionPlan(planId: 'basic', name: 'Basic', price: 5.0, period: 'monthly'),
        SubscriptionPlan(planId: 'premium', name: 'Premium', price: 15.0, period: 'monthly'),
      ];
    }
    return qs.docs.map((d) {
      final m = d.data();
      return SubscriptionPlan(
        planId: d.id,
        name: (m['name'] as String?) ?? d.id,
        price: ((m['price'] as num?) ?? 0).toDouble(),
        period: (m['period'] as String?) ?? 'monthly',
      );
    }).toList();
  }

  @override
  Future<UserSubscription?> getUserSubscription(String ownerUid) async {
    final doc = await db.collection('subscriptions').doc(ownerUid).get();
    if (!doc.exists) return null;
    final m = doc.data()!;
    return UserSubscription(
      ownerUid: ownerUid,
      planId: (m['planId'] as String?) ?? 'free',
      updatedAt: DateTime.parse(m['updatedAt'] as String),
      currentPeriodEnd: (m['currentPeriodEnd'] as String?) != null
          ? DateTime.parse(m['currentPeriodEnd'] as String)
          : null,
    );
  }

  @override
  Future<void> setUserPlan(String ownerUid, String planId) async {
    final now = DateTime.now();
    await db.collection('subscriptions').doc(ownerUid).set({
      'planId': planId,
      'updatedAt': now.toIso8601String(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> addInvoice(String ownerUid, double amount, String note) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await db.collection('invoices').doc(id).set({
      'invoiceId': id,
      'ownerUid': ownerUid,
      'amount': amount,
      'note': note,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<List<InvoiceItem>> listInvoices(String ownerUid, {int limit = 20}) async {
    final qs = await db
        .collection('invoices')
        .where('ownerUid', isEqualTo: ownerUid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return qs.docs.map((d) {
      final m = d.data();
      return InvoiceItem(
        invoiceId: m['invoiceId'] as String,
        ownerUid: m['ownerUid'] as String,
        note: (m['note'] as String?) ?? '',
        amount: (m['amount'] as num).toDouble(),
        createdAt: DateTime.parse(m['createdAt'] as String),
      );
    }).toList();
  }
}

