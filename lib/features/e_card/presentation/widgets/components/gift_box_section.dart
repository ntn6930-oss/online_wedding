import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:online_wedding/core/localization/localization.dart';

class GiftBoxSection extends ConsumerWidget {
  final String brideLabel;
  final String groomLabel;
  final String brideData;
  final String groomData;
  const GiftBoxSection({
    super.key,
    required this.brideLabel,
    required this.groomLabel,
    required this.brideData,
    required this.groomData,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t('gift.box'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _GiftCard(label: brideLabel, data: brideData)),
              const SizedBox(width: 8),
              Expanded(child: _GiftCard(label: groomLabel, data: groomData)),
            ],
          ),
        ],
      ),
    );
  }
}

class _GiftCard extends StatelessWidget {
  final String label;
  final String data;
  const _GiftCard({required this.label, required this.data});
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
            QrImageView(data: data, size: 140),
          ],
        ),
      ),
    );
  }
}
