import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/core/usecases/usecase.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';

import 'create_new_card_use_case.dart';

final getCardByIdUseCaseProvider = Provider<GetCardByIdUseCase>((ref) {
  final repo = ref.watch(eCardRepositoryProvider);
  return GetCardByIdUseCase(repo);
});

class GetCardByIdParams extends Equatable {
  final String cardId;
  const GetCardByIdParams(this.cardId);
  @override
  List<Object?> get props => [cardId];
}

class GetCardByIdUseCase
    extends UseCase<WeddingCardEntity, GetCardByIdParams> {
  final ECardRepository repository;
  GetCardByIdUseCase(this.repository);

  @override
  Future<Either<Failure, WeddingCardEntity>> call(
    GetCardByIdParams params,
  ) async {
    return await repository.getCardById(params.cardId);
  }
}
