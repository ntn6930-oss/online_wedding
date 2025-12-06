import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/core/usecases/usecase.dart';
import 'package:online_wedding/features/e_card/domain/entities/guest_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';

import 'create_new_card_use_case.dart';

final addGuestUseCaseProvider = Provider<AddGuestUseCase>((ref) {
  final repo = ref.watch(eCardRepositoryProvider);
  return AddGuestUseCase(repo);
});

final listGuestsUseCaseProvider = Provider<ListGuestsUseCase>((ref) {
  final repo = ref.watch(eCardRepositoryProvider);
  return ListGuestsUseCase(repo);
});

class AddGuestParams extends Equatable {
  final String cardId;
  final GuestEntity guest;
  const AddGuestParams({required this.cardId, required this.guest});
  @override
  List<Object?> get props => [cardId, guest];
}

class ListGuestsParams extends Equatable {
  final String cardId;
  const ListGuestsParams(this.cardId);
  @override
  List<Object?> get props => [cardId];
}

class AddGuestUseCase extends UseCase<Unit, AddGuestParams> {
  final ECardRepository repository;
  AddGuestUseCase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(AddGuestParams params) async {
    return await repository.addGuest(params.cardId, params.guest);
  }
}

class ListGuestsUseCase extends UseCase<List<GuestEntity>, ListGuestsParams> {
  final ECardRepository repository;
  ListGuestsUseCase(this.repository);
  @override
  Future<Either<Failure, List<GuestEntity>>> call(ListGuestsParams params) async {
    return await repository.listGuests(params.cardId);
  }
}
