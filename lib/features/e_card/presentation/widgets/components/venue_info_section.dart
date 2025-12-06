import 'package:flutter/material.dart';

class VenueInfoSection extends StatelessWidget {
  final String? brideVenue;
  final String? groomVenue;
  const VenueInfoSection({
    super.key,
    this.brideVenue,
    this.groomVenue,
  });
  @override
  Widget build(BuildContext context) {
    final items = [
      _VenueCard(label: 'Nhà gái', address: brideVenue),
      _VenueCard(label: 'Nhà trai', address: groomVenue),
    ].where((e) => e.address != null && e.address!.isNotEmpty).toList();
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: items
            .map((w) => Expanded(child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: w,
                )))
            .toList(),
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  final String label;
  final String? address;
  const _VenueCard({required this.label, this.address});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(address ?? ''),
          ],
        ),
      ),
    );
  }
}

