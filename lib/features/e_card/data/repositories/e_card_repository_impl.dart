import 'package:dartz/dartz.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/features/e_card/domain/entities/wedding_card_entity.dart';
import 'package:online_wedding/features/e_card/domain/entities/guest_entity.dart';
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';
import 'package:online_wedding/features/e_card/domain/usecases/create_new_card_use_case.dart';
import 'package:online_wedding/features/e_card/data/datasources/card_remote_data_source.dart';

class ECardRepositoryImpl implements ECardRepository {
  final CardRemoteDataSource remote;
  ECardRepositoryImpl({CardRemoteDataSource? remote})
      : remote = remote ?? InMemoryCardRemoteDataSource();
  @override
  Future<Either<Failure, WeddingCardEntity>> createNewCard(
    CreateNewCardParams params,
  ) async {
    try {
      final card = await remote.createCard(params);
      return Right(card);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, WeddingCardEntity>> getCardById(
    String cardId,
  ) async {
    try {
      final card = await remote.getCardById(cardId);
      if (card == null) {
        return Left(CacheFailure());
      }
      return Right(card);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> registerSlug(String slug, String cardId) async {
    try {
      await remote.registerSlug(slug, cardId);
      return const Right(unit);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, WeddingCardEntity>> getCardBySlug(String slug) async {
    try {
      final id = await remote.getCardIdBySlug(slug);
      if (id == null) return Left(CacheFailure());
      final card = await remote.getCardById(id);
      if (card == null) return Left(CacheFailure());
      return Right(card);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addGuest(String cardId, GuestEntity guest) async {
    try {
      final model = GuestModel(
        guestId: guest.guestId,
        name: guest.name,
        invited: guest.invited,
        attended: guest.attended,
        giftAmount: guest.giftAmount,
      );
      await remote.addGuest(cardId, model);
      return const Right(unit);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<GuestEntity>>> listGuests(String cardId) async {
    try {
      final models = await remote.listGuests(cardId);
      final guests = models
          .map(
            (m) => GuestEntity(
              guestId: m.guestId,
              name: m.name,
              invited: m.invited,
              attended: m.attended,
              giftAmount: m.giftAmount,
            ),
          )
          .toList();
      return Right(guests);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> setPublicStatus(String cardId, bool isPublic) async {
    try {
      await remote.setPublic(cardId, isPublic);
      return const Right(unit);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getPublicStatus(String cardId) async {
    try {
      final v = await remote.isPublic(cardId);
      return Right(v);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveCustomization(
    String cardId,
    CardCustomizationEntity customization,
  ) async {
    try {
      await remote.setCustomization(cardId, {
        'primaryColorHex': customization.primaryColorHex,
        'font': customization.font,
        'showMap': customization.showMap,
        'showAlbum': customization.showAlbum,
        'showCountdown': customization.showCountdown,
      });
      return const Right(unit);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CardCustomizationEntity>> getCustomization(String cardId) async {
    try {
      final m = await remote.getCustomization(cardId);
      if (m == null) return Left(CacheFailure());
      return Right(CardCustomizationEntity(
        primaryColorHex: m['primaryColorHex'] as String,
        font: m['font'] as String,
        showMap: m['showMap'] as bool,
        showAlbum: m['showAlbum'] as bool,
        showCountdown: m['showCountdown'] as bool,
      ));
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String cardId, String fileName, List<int> bytes) async {
    try {
      final url = await remote.uploadImage(cardId, fileName, bytes);
      return Right(url);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> listImages(String cardId) async {
    try {
      final list = await remote.listImages(cardId);
      return Right(list);
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
