// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TemplateEntity {
  String get templateId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  bool get hasVideo => throw _privateConstructorUsedError;
  String get primaryColorHex => throw _privateConstructorUsedError;
  List<String> get fonts => throw _privateConstructorUsedError;
  String get previewUrl => throw _privateConstructorUsedError;

  /// Create a copy of TemplateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemplateEntityCopyWith<TemplateEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateEntityCopyWith<$Res> {
  factory $TemplateEntityCopyWith(
    TemplateEntity value,
    $Res Function(TemplateEntity) then,
  ) = _$TemplateEntityCopyWithImpl<$Res, TemplateEntity>;
  @useResult
  $Res call({
    String templateId,
    String name,
    String category,
    bool hasVideo,
    String primaryColorHex,
    List<String> fonts,
    String previewUrl,
  });
}

/// @nodoc
class _$TemplateEntityCopyWithImpl<$Res, $Val extends TemplateEntity>
    implements $TemplateEntityCopyWith<$Res> {
  _$TemplateEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TemplateEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? name = null,
    Object? category = null,
    Object? hasVideo = null,
    Object? primaryColorHex = null,
    Object? fonts = null,
    Object? previewUrl = null,
  }) {
    return _then(
      _value.copyWith(
            templateId: null == templateId
                ? _value.templateId
                : templateId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            hasVideo: null == hasVideo
                ? _value.hasVideo
                : hasVideo // ignore: cast_nullable_to_non_nullable
                      as bool,
            primaryColorHex: null == primaryColorHex
                ? _value.primaryColorHex
                : primaryColorHex // ignore: cast_nullable_to_non_nullable
                      as String,
            fonts: null == fonts
                ? _value.fonts
                : fonts // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            previewUrl: null == previewUrl
                ? _value.previewUrl
                : previewUrl // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TemplateEntityImplCopyWith<$Res>
    implements $TemplateEntityCopyWith<$Res> {
  factory _$$TemplateEntityImplCopyWith(
    _$TemplateEntityImpl value,
    $Res Function(_$TemplateEntityImpl) then,
  ) = __$$TemplateEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String templateId,
    String name,
    String category,
    bool hasVideo,
    String primaryColorHex,
    List<String> fonts,
    String previewUrl,
  });
}

/// @nodoc
class __$$TemplateEntityImplCopyWithImpl<$Res>
    extends _$TemplateEntityCopyWithImpl<$Res, _$TemplateEntityImpl>
    implements _$$TemplateEntityImplCopyWith<$Res> {
  __$$TemplateEntityImplCopyWithImpl(
    _$TemplateEntityImpl _value,
    $Res Function(_$TemplateEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TemplateEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? name = null,
    Object? category = null,
    Object? hasVideo = null,
    Object? primaryColorHex = null,
    Object? fonts = null,
    Object? previewUrl = null,
  }) {
    return _then(
      _$TemplateEntityImpl(
        templateId: null == templateId
            ? _value.templateId
            : templateId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        hasVideo: null == hasVideo
            ? _value.hasVideo
            : hasVideo // ignore: cast_nullable_to_non_nullable
                  as bool,
        primaryColorHex: null == primaryColorHex
            ? _value.primaryColorHex
            : primaryColorHex // ignore: cast_nullable_to_non_nullable
                  as String,
        fonts: null == fonts
            ? _value._fonts
            : fonts // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        previewUrl: null == previewUrl
            ? _value.previewUrl
            : previewUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TemplateEntityImpl implements _TemplateEntity {
  const _$TemplateEntityImpl({
    required this.templateId,
    required this.name,
    required this.category,
    required this.hasVideo,
    required this.primaryColorHex,
    required final List<String> fonts,
    required this.previewUrl,
  }) : _fonts = fonts;

  @override
  final String templateId;
  @override
  final String name;
  @override
  final String category;
  @override
  final bool hasVideo;
  @override
  final String primaryColorHex;
  final List<String> _fonts;
  @override
  List<String> get fonts {
    if (_fonts is EqualUnmodifiableListView) return _fonts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fonts);
  }

  @override
  final String previewUrl;

  @override
  String toString() {
    return 'TemplateEntity(templateId: $templateId, name: $name, category: $category, hasVideo: $hasVideo, primaryColorHex: $primaryColorHex, fonts: $fonts, previewUrl: $previewUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateEntityImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.hasVideo, hasVideo) ||
                other.hasVideo == hasVideo) &&
            (identical(other.primaryColorHex, primaryColorHex) ||
                other.primaryColorHex == primaryColorHex) &&
            const DeepCollectionEquality().equals(other._fonts, _fonts) &&
            (identical(other.previewUrl, previewUrl) ||
                other.previewUrl == previewUrl));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    templateId,
    name,
    category,
    hasVideo,
    primaryColorHex,
    const DeepCollectionEquality().hash(_fonts),
    previewUrl,
  );

  /// Create a copy of TemplateEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateEntityImplCopyWith<_$TemplateEntityImpl> get copyWith =>
      __$$TemplateEntityImplCopyWithImpl<_$TemplateEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _TemplateEntity implements TemplateEntity {
  const factory _TemplateEntity({
    required final String templateId,
    required final String name,
    required final String category,
    required final bool hasVideo,
    required final String primaryColorHex,
    required final List<String> fonts,
    required final String previewUrl,
  }) = _$TemplateEntityImpl;

  @override
  String get templateId;
  @override
  String get name;
  @override
  String get category;
  @override
  bool get hasVideo;
  @override
  String get primaryColorHex;
  @override
  List<String> get fonts;
  @override
  String get previewUrl;

  /// Create a copy of TemplateEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemplateEntityImplCopyWith<_$TemplateEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
