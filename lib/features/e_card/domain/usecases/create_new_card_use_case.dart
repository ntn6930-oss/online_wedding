import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wedding_card_entity.dart';
import '../repositories/e_card_repository.dart';

final createNewCardUseCaseProvider =
    Provider<CreateNewCardUseCase>((ref) {
  final repository = ref.watch(eCardRepositoryProvider);
  return CreateNewCardUseCase(repository);
});

class CreateNewCardUseCase
    extends UseCase<WeddingCardEntity, CreateNewCardParams> {
  final ECardRepository repository;

  CreateNewCardUseCase(this.repository);

  @override
  Future<Either<Failure, WeddingCardEntity>> call(
    CreateNewCardParams params,
  ) async {
    return await repository.createNewCard(params);
  }
}

class CreateNewCardParams extends Equatable {
  final String templateId;
  final String coupleName;
  final DateTime date;
  final bool isPremium;

  const CreateNewCardParams({
    required this.templateId,
    required this.coupleName,
    required this.date,
    required this.isPremium,
  });

  @override
  List<Object?> get props => [templateId, coupleName, date, isPremium];
}

final eCardRepositoryProvider = Provider<ECardRepository>((ref) {
  throw UnimplementedError();
});
