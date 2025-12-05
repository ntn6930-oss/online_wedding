import 'package:dartz/dartz.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/create_new_card_use_case.dart';

abstract class ECardRepository {
  Future<Either<Failure, WeddingCardEntity>> createNewCard(
    CreateNewCardParams params,
  );
}