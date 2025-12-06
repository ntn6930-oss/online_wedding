import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/core/localization/localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../domain/entities/guest_entity.dart';
import '../../../domain/usecases/create_new_card_use_case.dart';

class RsvpSection extends ConsumerStatefulWidget {
  final String cardId;
  const RsvpSection({super.key, required this.cardId});
  @override
  ConsumerState<RsvpSection> createState() => _RsvpSectionState();
}

class _RsvpSectionState extends ConsumerState<RsvpSection> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  bool attending = true;
  int guestsCount = 1;
  String side = 'bride';
  DateTime lastSubmit = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(tProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t('rsvp.title'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name'))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone'))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            DropdownButton<String>(
              value: side,
              items: [
                DropdownMenuItem(value: 'bride', child: Text(t('rsvp.bride'))),
                DropdownMenuItem(value: 'groom', child: Text(t('rsvp.groom'))),
              ],
              onChanged: (v) => setState(() => side = v ?? 'bride'),
            ),
            const SizedBox(width: 12),
            Switch(
              value: attending,
              onChanged: (v) => setState(() => attending = v),
            ),
            const SizedBox(width: 4),
            Text(attending ? t('rsvp.attending_yes') : t('rsvp.attending_no')),
            const SizedBox(width: 12),
            DropdownButton<int>(
              value: guestsCount,
              items: [1, 2, 3, 4]
                  .map((g) => DropdownMenuItem<int>(value: g, child: Text('$g')))
                  .toList(),
              onChanged: (v) => setState(() => guestsCount = v ?? 1),
            ),
            const SizedBox(width: 4),
            Text(t('rsvp.guests_count')),
          ]),
          const SizedBox(height: 8),
          TextField(controller: noteCtrl, decoration: InputDecoration(labelText: t('rsvp.note'))),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final now = DateTime.now();
              if (now.difference(lastSubmit).inSeconds < 10) return;
              lastSubmit = now;
              final name = nameCtrl.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t('rsvp.invalid'))),
                );
                return;
              }
              final callable = FirebaseFunctions.instance.httpsCallable('submitRSVP');
              await callable.call({
                'cardId': widget.cardId,
                'name': name,
                'phone': phoneCtrl.text.trim(),
                'note': noteCtrl.text.trim(),
                'side': side,
                'attending': attending,
                'guestsCount': guestsCount,
                'recaptchaToken': '',
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t('rsvp.submit'))),
              );
            },
            child: Text(t('rsvp.submit')),
          ),
        ],
      ),
    );
  }
}
