import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:online_wedding/features/e_card/domain/entities/card_customization_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/e_card_repository.dart';

import '../../domain/usecases/create_new_card_use_case.dart';

class CustomizationState {
  final Color primaryColor;
  final String font;
  final bool showMap;
  final bool showAlbum;
  final bool showCountdown;
  CustomizationState({
    required this.primaryColor,
    required this.font,
    required this.showMap,
    required this.showAlbum,
    required this.showCountdown,
  });
  CustomizationState copyWith({
    Color? primaryColor,
    String? font,
    bool? showMap,
    bool? showAlbum,
    bool? showCountdown,
  }) {
    return CustomizationState(
      primaryColor: primaryColor ?? this.primaryColor,
      font: font ?? this.font,
      showMap: showMap ?? this.showMap,
      showAlbum: showAlbum ?? this.showAlbum,
      showCountdown: showCountdown ?? this.showCountdown,
    );
  }
}

final customizationProvider = StateProvider<CustomizationState>((ref) {
  return CustomizationState(
    primaryColor: Colors.deepPurple,
    font: 'Default',
    showMap: true,
    showAlbum: true,
    showCountdown: false,
  );
});

class DesignCustomizationPage extends ConsumerWidget {
  const DesignCustomizationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customizationProvider);
    final fonts = ['Default', 'Serif', 'Sans', 'Monospace'];
    final colors = [
      Colors.deepPurple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.green,
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Tùy chỉnh thiết kế')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Màu chủ đạo'),
            Wrap(
              spacing: 8,
              children: colors.map((c) {
                return GestureDetector(
                  onTap: () => ref
                      .read(customizationProvider.notifier)
                      .state = state.copyWith(primaryColor: c),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Font chữ'),
            DropdownButton<String>(
              value: state.font,
              items: fonts
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  ref.read(customizationProvider.notifier).state =
                      state.copyWith(font: v);
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Bản đồ'),
              value: state.showMap,
              onChanged: (v) => ref.read(customizationProvider.notifier).state =
                  state.copyWith(showMap: v),
            ),
            SwitchListTile(
              title: const Text('Album ảnh'),
              value: state.showAlbum,
              onChanged: (v) => ref.read(customizationProvider.notifier).state =
                  state.copyWith(showAlbum: v),
            ),
            SwitchListTile(
              title: const Text('Đếm ngược'),
              value: state.showCountdown,
              onChanged: (v) => ref.read(customizationProvider.notifier).state =
                  state.copyWith(showCountdown: v),
            ),
            const SizedBox(height: 24),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: state.primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                'Xem trước',
                style: TextStyle(
                  color: state.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DesignCustomizationPageWithId extends ConsumerWidget {
  final String cardId;
  const DesignCustomizationPageWithId({super.key, required this.cardId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customizationProvider);
    final images = ref.watch(_imagesProvider(cardId));
    return Scaffold(
      appBar: AppBar(title: const Text('Tùy chỉnh thiết kế')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DesignCustomizationPage(),
            const SizedBox(height: 16),
            Row(children: [
              ElevatedButton(
                onPressed: () async {
                  final repo = ref.read(eCardRepositoryProvider);
                  final ok = await repo.saveCustomization(
                    cardId,
                    CardCustomizationState(
                      primaryColorHex: '#${state.primaryColor.value.toRadixString(16)}',
                      font: state.font,
                      showMap: state.showMap,
                      showAlbum: state.showAlbum,
                      showCountdown: state.showCountdown,
                    ) as CardCustomizationEntity,
                  );
                },
                child: const Text('Lưu thiết kế'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final file = await picker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    final raw = await file.readAsBytes();
                    final compressed = _compress(raw);
                    final repo = ref.read(eCardRepositoryProvider);
                    await repo.uploadImage(cardId, file.name, compressed);
                    ref.refresh(_imagesProvider(cardId));
                  }
                },
                child: const Text('Tải ảnh lên'),
              ),
            ]),
            const SizedBox(height: 16),
            images.when(
              data: (list) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: list
                    .map((url) => Image.network(url, width: 120, height: 80, fit: BoxFit.cover))
                    .toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class CardCustomizationState {
  final String primaryColorHex;
  final String font;
  final bool showMap;
  final bool showAlbum;
  final bool showCountdown;
  CardCustomizationState({
    required this.primaryColorHex,
    required this.font,
    required this.showMap,
    required this.showAlbum,
    required this.showCountdown,
  });
}

final _imagesProvider = FutureProvider.family<List<String>, String>((ref, id) async {
  final repo = ref.read(eCardRepositoryProvider);
  final res = await repo.listImages(id);
  return res.fold((l) => [], (r) => r);
});

List<int> _compress(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return bytes;
  final maxW = 1280;
  final w = decoded.width;
  final h = decoded.height;
  img.Image resized = decoded;
  if (w > maxW) {
    final nh = (h * maxW / w).round();
    resized = img.copyResize(decoded, width: maxW, height: nh);
  }
  return img.encodeJpg(resized, quality: 85);
}
