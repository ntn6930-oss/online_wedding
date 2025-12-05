import 'package:freezed_annotation/freezed_annotation.dart';

part 'wedding_card_entity.freezed.dart';

@freezed
class WeddingCardEntity with _$WeddingCardEntity {
  const factory WeddingCardEntity({
    required String cardId,
    required String templateId,
    required String coupleName,
    required DateTime date,
    required String storageUrl,
    required bool isPremium,
  }) = _WeddingCardEntity;
}