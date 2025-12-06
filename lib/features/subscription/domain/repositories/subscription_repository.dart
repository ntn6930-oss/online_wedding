import 'package:dartz/dartz.dart';
import 'package:online_wedding/core/error/failures.dart';

class SubscriptionPlan {
  final String planId;
  final String name;
  final double price;
  final String period;
  const SubscriptionPlan({
    required this.planId,
    required this.name,
    required this.price,
    required this.period,
  });
}

class UserSubscription {
  final String ownerUid;
  final String planId;
  final DateTime updatedAt;
  final DateTime? currentPeriodEnd;
  const UserSubscription({
    required this.ownerUid,
    required this.planId,
    required this.updatedAt,
    this.currentPeriodEnd,
  });
}

class InvoiceItem {
  final String invoiceId;
  final String ownerUid;
  final String note;
  final double amount;
  final DateTime createdAt;
  const InvoiceItem({
    required this.invoiceId,
    required this.ownerUid,
    required this.note,
    required this.amount,
    required this.createdAt,
  });
}

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionPlan>>> listPlans();
  Future<Either<Failure, UserSubscription?>> getUserSubscription(String ownerUid);
  Future<Either<Failure, Unit>> setUserPlan(String ownerUid, String planId);
  Future<Either<Failure, Unit>> addInvoice(String ownerUid, double amount, String note);
  Future<Either<Failure, List<InvoiceItem>>> listInvoices(String ownerUid, {int limit = 20});
}

