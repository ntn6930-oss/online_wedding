import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:online_wedding/features/subscription/data/datasources/subscription_remote_data_source_firestore.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remote;
  SubscriptionRepositoryImpl({SubscriptionRemoteDataSource? remote})
      : remote = remote ?? FirestoreSubscriptionRemoteDataSource(FirebaseFirestore.instance);
  @override
  Future<Either<Failure, List<SubscriptionPlan>>> listPlans() async {
    try {
      final items = await remote.listPlans();
      return Right(items);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserSubscription?>> getUserSubscription(String ownerUid) async {
    try {
      final sub = await remote.getUserSubscription(ownerUid);
      return Right(sub);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> setUserPlan(String ownerUid, String planId) async {
    try {
      await remote.setUserPlan(ownerUid, planId);
      return const Right(unit);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addInvoice(String ownerUid, double amount, String note) async {
    try {
      await remote.addInvoice(ownerUid, amount, note);
      return const Right(unit);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<InvoiceItem>>> listInvoices(String ownerUid, {int limit = 20}) async {
    try {
      final items = await remote.listInvoices(ownerUid, limit: limit);
      return Right(items);
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}

