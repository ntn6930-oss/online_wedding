// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guest_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GuestEntity {
  String get guestId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get invited => throw _privateConstructorUsedError;
  bool get attended => throw _privateConstructorUsedError;
  double get giftAmount => throw _privateConstructorUsedError;

  /// Create a copy of GuestEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuestEntityCopyWith<GuestEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuestEntityCopyWith<$Res> {
  factory $GuestEntityCopyWith(
    GuestEntity value,
    $Res Function(GuestEntity) then,
  ) = _$GuestEntityCopyWithImpl<$Res, GuestEntity>;
  @useResult
  $Res call({
    String guestId,
    String name,
    bool invited,
    bool attended,
    double giftAmount,
  });
}

/// @nodoc
class _$GuestEntityCopyWithImpl<$Res, $Val extends GuestEntity>
    implements $GuestEntityCopyWith<$Res> {
  _$GuestEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GuestEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? guestId = null,
    Object? name = null,
    Object? invited = null,
    Object? attended = null,
    Object? giftAmount = null,
  }) {
    return _then(
      _value.copyWith(
            guestId: null == guestId
                ? _value.guestId
                : guestId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            invited: null == invited
                ? _value.invited
                : invited // ignore: cast_nullable_to_non_nullable
                      as bool,
            attended: null == attended
                ? _value.attended
                : attended // ignore: cast_nullable_to_non_nullable
                      as bool,
            giftAmount: null == giftAmount
                ? _value.giftAmount
                : giftAmount // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GuestEntityImplCopyWith<$Res>
    implements $GuestEntityCopyWith<$Res> {
  factory _$$GuestEntityImplCopyWith(
    _$GuestEntityImpl value,
    $Res Function(_$GuestEntityImpl) then,
  ) = __$$GuestEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String guestId,
    String name,
    bool invited,
    bool attended,
    double giftAmount,
  });
}

/// @nodoc
class __$$GuestEntityImplCopyWithImpl<$Res>
    extends _$GuestEntityCopyWithImpl<$Res, _$GuestEntityImpl>
    implements _$$GuestEntityImplCopyWith<$Res> {
  __$$GuestEntityImplCopyWithImpl(
    _$GuestEntityImpl _value,
    $Res Function(_$GuestEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GuestEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? guestId = null,
    Object? name = null,
    Object? invited = null,
    Object? attended = null,
    Object? giftAmount = null,
  }) {
    return _then(
      _$GuestEntityImpl(
        guestId: null == guestId
            ? _value.guestId
            : guestId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        invited: null == invited
            ? _value.invited
            : invited // ignore: cast_nullable_to_non_nullable
                  as bool,
        attended: null == attended
            ? _value.attended
            : attended // ignore: cast_nullable_to_non_nullable
                  as bool,
        giftAmount: null == giftAmount
            ? _value.giftAmount
            : giftAmount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$GuestEntityImpl implements _GuestEntity {
  const _$GuestEntityImpl({
    required this.guestId,
    required this.name,
    required this.invited,
    required this.attended,
    required this.giftAmount,
  });

  @override
  final String guestId;
  @override
  final String name;
  @override
  final bool invited;
  @override
  final bool attended;
  @override
  final double giftAmount;

  @override
  String toString() {
    return 'GuestEntity(guestId: $guestId, name: $name, invited: $invited, attended: $attended, giftAmount: $giftAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuestEntityImpl &&
            (identical(other.guestId, guestId) || other.guestId == guestId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.invited, invited) || other.invited == invited) &&
            (identical(other.attended, attended) ||
                other.attended == attended) &&
            (identical(other.giftAmount, giftAmount) ||
                other.giftAmount == giftAmount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, guestId, name, invited, attended, giftAmount);

  /// Create a copy of GuestEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuestEntityImplCopyWith<_$GuestEntityImpl> get copyWith =>
      __$$GuestEntityImplCopyWithImpl<_$GuestEntityImpl>(this, _$identity);
}

abstract class _GuestEntity implements GuestEntity {
  const factory _GuestEntity({
    required final String guestId,
    required final String name,
    required final bool invited,
    required final bool attended,
    required final double giftAmount,
  }) = _$GuestEntityImpl;

  @override
  String get guestId;
  @override
  String get name;
  @override
  bool get invited;
  @override
  bool get attended;
  @override
  double get giftAmount;

  /// Create a copy of GuestEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuestEntityImplCopyWith<_$GuestEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
