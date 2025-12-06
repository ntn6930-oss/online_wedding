import 'package:flutter/material.dart';

class BrideGroomInfoSection extends StatelessWidget {
  final String? brideName;
  final String? groomName;
  final String? bridePhotoUrl;
  final String? groomPhotoUrl;
  const BrideGroomInfoSection({
    super.key,
    this.brideName,
    this.groomName,
    this.bridePhotoUrl,
    this.groomPhotoUrl,
  });
  @override
  Widget build(BuildContext context) {
    final items = [
      _PersonCard(label: 'Cô dâu', name: brideName, photoUrl: bridePhotoUrl),
      _PersonCard(label: 'Chú rể', name: groomName, photoUrl: groomPhotoUrl),
    ].where((e) => e.name != null && e.name!.isNotEmpty).toList();
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: items
            .map((w) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: w,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  final String label;
  final String? name;
  final String? photoUrl;
  const _PersonCard({
    required this.label,
    this.name,
    this.photoUrl,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (photoUrl != null && photoUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(photoUrl!, height: 120, fit: BoxFit.cover),
              ),
            const SizedBox(height: 8),
            Text(name ?? ''),
          ],
        ),
      ),
    );
  }
}

