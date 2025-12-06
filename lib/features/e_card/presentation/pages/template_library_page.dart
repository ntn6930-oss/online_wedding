import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/features/e_card/domain/entities/template_entity.dart';
import 'package:online_wedding/features/e_card/domain/usecases/list_templates_use_case.dart';

final _categoryFilterProvider = StateProvider<String?>((ref) => null);
final _queryProvider = StateProvider<String>((ref) => '');
final _videoOnlyProvider = StateProvider<bool>((ref) => false);

final _templatesProvider = FutureProvider<List<TemplateEntity>>((ref) async {
  final usecase = ref.read(listTemplatesUseCaseProvider);
  final res = await usecase.call(null);
  return res.fold((l) => [], (r) => r);
});

class TemplateLibraryPage extends ConsumerWidget {
  const TemplateLibraryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(_templatesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Thư viện Mẫu Thiệp')),
      body: Column(
        children: [
          TemplateFilterBar(),
          Expanded(child: TemplateGrid(state: items)),
        ],
      ),
    );
  }
}

class TemplateFilterBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = ref.watch(_categoryFilterProvider);
    final q = ref.watch(_queryProvider);
    final videoOnly = ref.watch(_videoOnlyProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          DropdownButton<String?>(
            value: cat,
            hint: const Text('Phong cách'),
            items: const [
              DropdownMenuItem(value: null, child: Text('Tất cả')),
              DropdownMenuItem(value: 'Modern', child: Text('Modern')),
              DropdownMenuItem(value: 'Classic', child: Text('Classic')),
              DropdownMenuItem(value: 'Minimalist', child: Text('Minimalist')),
            ],
            onChanged: (v) => ref.read(_categoryFilterProvider.notifier).state = v,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Tìm kiếm'),
              onChanged: (v) => ref.read(_queryProvider.notifier).state = v.trim(),
            ),
          ),
          const SizedBox(width: 12),
          Row(children: [
            const Text('Có video'),
            Switch(value: videoOnly, onChanged: (v)=>ref.read(_videoOnlyProvider.notifier).state = v),
          ]),
        ],
      ),
    );
  }
}

class TemplateGrid extends ConsumerWidget {
  final AsyncValue<List<TemplateEntity>> state;
  const TemplateGrid({super.key, required this.state});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = ref.watch(_categoryFilterProvider);
    final q = ref.watch(_queryProvider).toLowerCase();
    final videoOnly = ref.watch(_videoOnlyProvider);
    return state.when(
      data: (list) {
        final filtered = list.where((t) {
          final okCat = cat == null || t.category == cat;
          final okQ = q.isEmpty || t.name.toLowerCase().contains(q);
          final okVideo = !videoOnly || t.hasVideo;
          return okCat && okQ && okVideo;
        }).toList();
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: filtered.length,
          itemBuilder: (_, i) => TemplateCard(item: filtered[i]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text('Lỗi tải mẫu')),
    );
  }
}

class TemplateCard extends StatelessWidget {
  final TemplateEntity item;
  const TemplateCard({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(item.previewUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                Text(item.category),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
