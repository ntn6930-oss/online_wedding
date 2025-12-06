import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest_entity.freezed.dart';

@freezed
class GuestEntity with _$GuestEntity {
  const factory GuestEntity({
    required String guestId,
    required String name,
    required bool invited,
    required bool attended,
    required double giftAmount,
  }) = _GuestEntity;
}
