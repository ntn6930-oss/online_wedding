import 'package:flutter/material.dart';

class FamilyInfoSection extends StatelessWidget {
  final List<String> brideFamily;
  final List<String> groomFamily;
  const FamilyInfoSection({
    super.key,
    this.brideFamily = const [],
    this.groomFamily = const [],
  });
  @override
  Widget build(BuildContext context) {
    if (brideFamily.isEmpty && groomFamily.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          if (brideFamily.isNotEmpty)
            Expanded(child: _FamilyCard(label: 'Gia đình nhà gái', items: brideFamily)),
          const SizedBox(width: 8),
          if (groomFamily.isNotEmpty)
            Expanded(child: _FamilyCard(label: 'Gia đình nhà trai', items: groomFamily)),
        ],
      ),
    );
  }
}

class _FamilyCard extends StatelessWidget {
  final String label;
  final List<String> items;
  const _FamilyCard({required this.label, required this.items});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...items.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(e),
                )),
          ],
        ),
      ),
    );
  }
}

