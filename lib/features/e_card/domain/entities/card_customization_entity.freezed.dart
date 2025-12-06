// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_customization_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CardCustomizationEntity {
  String get primaryColorHex => throw _privateConstructorUsedError;
  String get font => throw _privateConstructorUsedError;
  bool get showMap => throw _privateConstructorUsedError;
  bool get showAlbum => throw _privateConstructorUsedError;
  bool get showCountdown => throw _privateConstructorUsedError;

  /// Create a copy of CardCustomizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardCustomizationEntityCopyWith<CardCustomizationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardCustomizationEntityCopyWith<$Res> {
  factory $CardCustomizationEntityCopyWith(
    CardCustomizationEntity value,
    $Res Function(CardCustomizationEntity) then,
  ) = _$CardCustomizationEntityCopyWithImpl<$Res, CardCustomizationEntity>;
  @useResult
  $Res call({
    String primaryColorHex,
    String font,
    bool showMap,
    bool showAlbum,
    bool showCountdown,
  });
}

/// @nodoc
class _$CardCustomizationEntityCopyWithImpl<
  $Res,
  $Val extends CardCustomizationEntity
>
    implements $CardCustomizationEntityCopyWith<$Res> {
  _$CardCustomizationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardCustomizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryColorHex = null,
    Object? font = null,
    Object? showMap = null,
    Object? showAlbum = null,
    Object? showCountdown = null,
  }) {
    return _then(
      _value.copyWith(
            primaryColorHex: null == primaryColorHex
                ? _value.primaryColorHex
                : primaryColorHex // ignore: cast_nullable_to_non_nullable
                      as String,
            font: null == font
                ? _value.font
                : font // ignore: cast_nullable_to_non_nullable
                      as String,
            showMap: null == showMap
                ? _value.showMap
                : showMap // ignore: cast_nullable_to_non_nullable
                      as bool,
            showAlbum: null == showAlbum
                ? _value.showAlbum
                : showAlbum // ignore: cast_nullable_to_non_nullable
                      as bool,
            showCountdown: null == showCountdown
                ? _value.showCountdown
                : showCountdown // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CardCustomizationEntityImplCopyWith<$Res>
    implements $CardCustomizationEntityCopyWith<$Res> {
  factory _$$CardCustomizationEntityImplCopyWith(
    _$CardCustomizationEntityImpl value,
    $Res Function(_$CardCustomizationEntityImpl) then,
  ) = __$$CardCustomizationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String primaryColorHex,
    String font,
    bool showMap,
    bool showAlbum,
    bool showCountdown,
  });
}

/// @nodoc
class __$$CardCustomizationEntityImplCopyWithImpl<$Res>
    extends
        _$CardCustomizationEntityCopyWithImpl<
          $Res,
          _$CardCustomizationEntityImpl
        >
    implements _$$CardCustomizationEntityImplCopyWith<$Res> {
  __$$CardCustomizationEntityImplCopyWithImpl(
    _$CardCustomizationEntityImpl _value,
    $Res Function(_$CardCustomizationEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CardCustomizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryColorHex = null,
    Object? font = null,
    Object? showMap = null,
    Object? showAlbum = null,
    Object? showCountdown = null,
  }) {
    return _then(
      _$CardCustomizationEntityImpl(
        primaryColorHex: null == primaryColorHex
            ? _value.primaryColorHex
            : primaryColorHex // ignore: cast_nullable_to_non_nullable
                  as String,
        font: null == font
            ? _value.font
            : font // ignore: cast_nullable_to_non_nullable
                  as String,
        showMap: null == showMap
            ? _value.showMap
            : showMap // ignore: cast_nullable_to_non_nullable
                  as bool,
        showAlbum: null == showAlbum
            ? _value.showAlbum
            : showAlbum // ignore: cast_nullable_to_non_nullable
                  as bool,
        showCountdown: null == showCountdown
            ? _value.showCountdown
            : showCountdown // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$CardCustomizationEntityImpl implements _CardCustomizationEntity {
  const _$CardCustomizationEntityImpl({
    required this.primaryColorHex,
    required this.font,
    required this.showMap,
    required this.showAlbum,
    required this.showCountdown,
  });

  @override
  final String primaryColorHex;
  @override
  final String font;
  @override
  final bool showMap;
  @override
  final bool showAlbum;
  @override
  final bool showCountdown;

  @override
  String toString() {
    return 'CardCustomizationEntity(primaryColorHex: $primaryColorHex, font: $font, showMap: $showMap, showAlbum: $showAlbum, showCountdown: $showCountdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardCustomizationEntityImpl &&
            (identical(other.primaryColorHex, primaryColorHex) ||
                other.primaryColorHex == primaryColorHex) &&
            (identical(other.font, font) || other.font == font) &&
            (identical(other.showMap, showMap) || other.showMap == showMap) &&
            (identical(other.showAlbum, showAlbum) ||
                other.showAlbum == showAlbum) &&
            (identical(other.showCountdown, showCountdown) ||
                other.showCountdown == showCountdown));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    primaryColorHex,
    font,
    showMap,
    showAlbum,
    showCountdown,
  );

  /// Create a copy of CardCustomizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardCustomizationEntityImplCopyWith<_$CardCustomizationEntityImpl>
  get copyWith =>
      __$$CardCustomizationEntityImplCopyWithImpl<
        _$CardCustomizationEntityImpl
      >(this, _$identity);
}

abstract class _CardCustomizationEntity implements CardCustomizationEntity {
  const factory _CardCustomizationEntity({
    required final String primaryColorHex,
    required final String font,
    required final bool showMap,
    required final bool showAlbum,
    required final bool showCountdown,
  }) = _$CardCustomizationEntityImpl;

  @override
  String get primaryColorHex;
  @override
  String get font;
  @override
  bool get showMap;
  @override
  bool get showAlbum;
  @override
  bool get showCountdown;

  /// Create a copy of CardCustomizationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardCustomizationEntityImplCopyWith<_$CardCustomizationEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
