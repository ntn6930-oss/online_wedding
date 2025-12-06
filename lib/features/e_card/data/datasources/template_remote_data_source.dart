import 'package:online_wedding/features/e_card/domain/entities/template_entity.dart';

abstract class TemplateRemoteDataSource {
  Future<List<TemplateEntity>> listTemplates();
}

class InMemoryTemplateRemoteDataSource implements TemplateRemoteDataSource {
  @override
  Future<List<TemplateEntity>> listTemplates() async {
    return [
      TemplateEntity(
        templateId: 'tpl_modern_01',
        name: 'Modern Aura',
        category: 'Modern',
        hasVideo: false,
        primaryColorHex: '#8E2DE2',
        fonts: ['Montserrat', 'Playfair'],
        previewUrl: 'https://via.placeholder.com/600x300?text=Modern+Aura',
      ),
      TemplateEntity(
        templateId: 'tpl_classic_01',
        name: 'Classic Rose',
        category: 'Classic',
        hasVideo: true,
        primaryColorHex: '#C2185B',
        fonts: ['Cormorant', 'Lato'],
        previewUrl: 'https://via.placeholder.com/600x300?text=Classic+Rose',
      ),
      TemplateEntity(
        templateId: 'tpl_min_01',
        name: 'Minimal Bliss',
        category: 'Minimalist',
        hasVideo: false,
        primaryColorHex: '#2E7D32',
        fonts: ['Inter', 'Nunito'],
        previewUrl: 'https://via.placeholder.com/600x300?text=Minimal+Bliss',
      ),
    ];
  }
}
