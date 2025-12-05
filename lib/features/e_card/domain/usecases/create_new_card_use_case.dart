import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/core/usecases/usecase.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';

final createNewCardUseCaseProvider = Provider<CreateNewCardUseCase>((ref) {
  // This will be updated later to use a real repository provider
  final repository = ref.watch(eCardRepositoryProvider);
  return CreateNewCardUseCase(repository);
});

class CreateNewCardUseCase extends UseCase<WeddingCardEntity, CreateNewCardParams> {
  final ECardRepository repository;

  CreateNewCardUseCase(this.repository);

  @override
  Future<Either<Failure, WeddingCardEntity>> call(CreateNewCardParams params) async {
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

// This is a placeholder for the actual repository provider
final eCardRepositoryProvider = Provider<ECardRepository>((ref) {
  throw UnimplementedError();
});