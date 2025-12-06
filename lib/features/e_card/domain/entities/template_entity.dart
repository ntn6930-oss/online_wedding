import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_entity.freezed.dart';

@freezed
class TemplateEntity with _$TemplateEntity {
  const factory TemplateEntity({
    required String templateId,
    required String name,
    required String category,
    required bool hasVideo,
    required String primaryColorHex,
    required List<String> fonts,
    required String previewUrl,
  }) = _TemplateEntity;
}
