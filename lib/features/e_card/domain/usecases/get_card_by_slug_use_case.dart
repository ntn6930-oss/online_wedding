import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/core/usecases/usecase.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';

import 'create_new_card_use_case.dart';

final getCardBySlugUseCaseProvider = Provider<GetCardBySlugUseCase>((ref) {
  final repo = ref.watch(eCardRepositoryProvider);
  return GetCardBySlugUseCase(repo);
});

class GetCardBySlugParams extends Equatable {
  final String slug;
  const GetCardBySlugParams(this.slug);
  @override
  List<Object?> get props => [slug];
}

class GetCardBySlugUseCase
    extends UseCase<WeddingCardEntity, GetCardBySlugParams> {
  final ECardRepository repository;
  GetCardBySlugUseCase(this.repository);

  @override
  Future<Either<Failure, WeddingCardEntity>> call(
    GetCardBySlugParams params,
  ) async {
    return await repository.getCardBySlug(params.slug);
  }
}
