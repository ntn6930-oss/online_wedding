// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wedding_card_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WeddingCardEntity {
  String get cardId => throw _privateConstructorUsedError;
  String get templateId => throw _privateConstructorUsedError;
  String get coupleName => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get storageUrl => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;

  /// Create a copy of WeddingCardEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeddingCardEntityCopyWith<WeddingCardEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeddingCardEntityCopyWith<$Res> {
  factory $WeddingCardEntityCopyWith(
    WeddingCardEntity value,
    $Res Function(WeddingCardEntity) then,
  ) = _$WeddingCardEntityCopyWithImpl<$Res, WeddingCardEntity>;
  @useResult
  $Res call({
    String cardId,
    String templateId,
    String coupleName,
    DateTime date,
    String storageUrl,
    bool isPremium,
  });
}

/// @nodoc
class _$WeddingCardEntityCopyWithImpl<$Res, $Val extends WeddingCardEntity>
    implements $WeddingCardEntityCopyWith<$Res> {
  _$WeddingCardEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeddingCardEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? templateId = null,
    Object? coupleName = null,
    Object? date = null,
    Object? storageUrl = null,
    Object? isPremium = null,
  }) {
    return _then(
      _value.copyWith(
            cardId: null == cardId
                ? _value.cardId
                : cardId // ignore: cast_nullable_to_non_nullable
                      as String,
            templateId: null == templateId
                ? _value.templateId
                : templateId // ignore: cast_nullable_to_non_nullable
                      as String,
            coupleName: null == coupleName
                ? _value.coupleName
                : coupleName // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            storageUrl: null == storageUrl
                ? _value.storageUrl
                : storageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            isPremium: null == isPremium
                ? _value.isPremium
                : isPremium // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeddingCardEntityImplCopyWith<$Res>
    implements $WeddingCardEntityCopyWith<$Res> {
  factory _$$WeddingCardEntityImplCopyWith(
    _$WeddingCardEntityImpl value,
    $Res Function(_$WeddingCardEntityImpl) then,
  ) = __$$WeddingCardEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String cardId,
    String templateId,
    String coupleName,
    DateTime date,
    String storageUrl,
    bool isPremium,
  });
}

/// @nodoc
class __$$WeddingCardEntityImplCopyWithImpl<$Res>
    extends _$WeddingCardEntityCopyWithImpl<$Res, _$WeddingCardEntityImpl>
    implements _$$WeddingCardEntityImplCopyWith<$Res> {
  __$$WeddingCardEntityImplCopyWithImpl(
    _$WeddingCardEntityImpl _value,
    $Res Function(_$WeddingCardEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeddingCardEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? templateId = null,
    Object? coupleName = null,
    Object? date = null,
    Object? storageUrl = null,
    Object? isPremium = null,
  }) {
    return _then(
      _$WeddingCardEntityImpl(
        cardId: null == cardId
            ? _value.cardId
            : cardId // ignore: cast_nullable_to_non_nullable
                  as String,
        templateId: null == templateId
            ? _value.templateId
            : templateId // ignore: cast_nullable_to_non_nullable
                  as String,
        coupleName: null == coupleName
            ? _value.coupleName
            : coupleName // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        storageUrl: null == storageUrl
            ? _value.storageUrl
            : storageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        isPremium: null == isPremium
            ? _value.isPremium
            : isPremium // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$WeddingCardEntityImpl implements _WeddingCardEntity {
  const _$WeddingCardEntityImpl({
    required this.cardId,
    required this.templateId,
    required this.coupleName,
    required this.date,
    required this.storageUrl,
    required this.isPremium,
  });

  @override
  final String cardId;
  @override
  final String templateId;
  @override
  final String coupleName;
  @override
  final DateTime date;
  @override
  final String storageUrl;
  @override
  final bool isPremium;

  @override
  String toString() {
    return 'WeddingCardEntity(cardId: $cardId, templateId: $templateId, coupleName: $coupleName, date: $date, storageUrl: $storageUrl, isPremium: $isPremium)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeddingCardEntityImpl &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.coupleName, coupleName) ||
                other.coupleName == coupleName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.storageUrl, storageUrl) ||
                other.storageUrl == storageUrl) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cardId,
    templateId,
    coupleName,
    date,
    storageUrl,
    isPremium,
  );

  /// Create a copy of WeddingCardEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeddingCardEntityImplCopyWith<_$WeddingCardEntityImpl> get copyWith =>
      __$$WeddingCardEntityImplCopyWithImpl<_$WeddingCardEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _WeddingCardEntity implements WeddingCardEntity {
  const factory _WeddingCardEntity({
    required final String cardId,
    required final String templateId,
    required final String coupleName,
    required final DateTime date,
    required final String storageUrl,
    required final bool isPremium,
  }) = _$WeddingCardEntityImpl;

  @override
  String get cardId;
  @override
  String get templateId;
  @override
  String get coupleName;
  @override
  DateTime get date;
  @override
  String get storageUrl;
  @override
  bool get isPremium;

  /// Create a copy of WeddingCardEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeddingCardEntityImplCopyWith<_$WeddingCardEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
