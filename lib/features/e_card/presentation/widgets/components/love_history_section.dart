import 'package:flutter/material.dart';

class LoveEvent {
  final String dateText;
  final String description;
  final String? photoUrl;
  LoveEvent({
    required this.dateText,
    required this.description,
    this.photoUrl,
  });
}

class LoveHistorySection extends StatelessWidget {
  final List<LoveEvent> events;
  const LoveHistorySection({super.key, this.events = const []});
  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Love History', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...events.map((e) => _TimelineItem(event: e)),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final LoveEvent event;
  const _TimelineItem({required this.event});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.photoUrl != null && event.photoUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(event.photoUrl!, width: 80, height: 80, fit: BoxFit.cover),
              ),
            if (event.photoUrl != null && event.photoUrl!.isNotEmpty)
              const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.dateText, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(event.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

