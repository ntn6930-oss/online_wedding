import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/core/usecases/usecase.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';

import 'create_new_card_use_case.dart';

final registerSlugUseCaseProvider = Provider<RegisterSlugUseCase>((ref) {
  final repo = ref.watch(eCardRepositoryProvider);
  return RegisterSlugUseCase(repo);
});

class RegisterSlugParams extends Equatable {
  final String slug;
  final String cardId;
  const RegisterSlugParams({required this.slug, required this.cardId});
  @override
  List<Object?> get props => [slug, cardId];
}

class RegisterSlugUseCase extends UseCase<Unit, RegisterSlugParams> {
  final ECardRepository repository;
  RegisterSlugUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RegisterSlugParams params) async {
    return await repository.registerSlug(params.slug, params.cardId);
  }
}
