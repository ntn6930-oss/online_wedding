import 'package:dartz/dartz.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/create_new_card_use_case.dart';

import '../entities/guest_entity.dart';

abstract class ECardRepository {
  Future<Either<Failure, WeddingCardEntity>> createNewCard(
    CreateNewCardParams params,
  );
  Future<Either<Failure, WeddingCardEntity>> getCardById(String cardId);
  Future<Either<Failure, List<WeddingCardEntity>>> listCardsByOwner(String ownerUid);
  Future<Either<Failure, List<WeddingCardEntity>>> listCardsByOwnerPaged(String ownerUid, int limit, DateTime? startAfterDate);
  Future<Either<Failure, Unit>> registerSlug(String slug, String cardId);
  Future<Either<Failure, WeddingCardEntity>> getCardBySlug(String slug);
  Future<Either<Failure, Unit>> addGuest(String cardId, GuestEntity guest);
  Future<Either<Failure, List<GuestEntity>>> listGuests(String cardId);
  Future<Either<Failure, List<GuestEntity>>> listGuestsPaged(String cardId, int limit, String? startAfterGuestId);
  Future<Either<Failure, Unit>> setPublicStatus(String cardId, bool isPublic);
  Future<Either<Failure, bool>> getPublicStatus(String cardId);
  Future<Either<Failure, Unit>> saveCustomization(String cardId, CardCustomizationEntity customization);
  Future<Either<Failure, CardCustomizationEntity>> getCustomization(String cardId);
  Future<Either<Failure, String>> uploadImage(String cardId, String fileName, List<int> bytes);
  Future<Either<Failure, List<String>>> listImages(String cardId);
}
