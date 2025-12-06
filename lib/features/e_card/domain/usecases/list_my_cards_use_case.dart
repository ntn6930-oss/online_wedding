import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/core/usecases/usecase.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';

import 'create_new_card_use_case.dart';

final listMyCardsUseCaseProvider = Provider<ListMyCardsUseCase>((ref) {
  final repo = ref.watch(eCardRepositoryProvider);
  return ListMyCardsUseCase(repo);
});

class ListMyCardsUseCase extends UseCase<List<WeddingCardEntity>, String> {
  final ECardRepository repository;
  ListMyCardsUseCase(this.repository);
  @override
  Future<Either<Failure, List<WeddingCardEntity>>> call(String uid) async {
    return repository.listCardsByOwner(uid);
  }
}

