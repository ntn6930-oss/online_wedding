import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_customization_entity.freezed.dart';

@freezed
class CardCustomizationEntity with _$CardCustomizationEntity {
  const factory CardCustomizationEntity({
    required String primaryColorHex,
    required String font,
    required bool showMap,
    required bool showAlbum,
    required bool showCountdown,
  }) = _CardCustomizationEntity;
}
