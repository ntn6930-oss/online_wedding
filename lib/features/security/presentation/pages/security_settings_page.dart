import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_wedding/core/localization/localization.dart';

class SecuritySettingsPage extends ConsumerStatefulWidget {
  const SecuritySettingsPage({super.key});
  @override
  ConsumerState<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends ConsumerState<SecuritySettingsPage> {
  String? otpauthUrl;
  final codeCtrl = TextEditingController();
  @override
  void dispose() {
    codeCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final t = ref.watch(tProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(t('security.title'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              ElevatedButton(
                onPressed: uid.isEmpty
                    ? null
                    : () async {
                        final callable = FirebaseFunctions.instance.httpsCallable('initTotpEnrollment');
                        final res = await callable.call({});
                        final url = (res.data ?? {})['otpauthUrl'] as String?;
                        setState(() => otpauthUrl = url);
                      },
                child: Text(t('security.enable_2fa')),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/security/webauthn-register'),
                child: Text(t('security.register_key')),
              ),
            ]),
            const SizedBox(height: 12),
            if (otpauthUrl != null && otpauthUrl!.isNotEmpty) ...[
              QrImageView(data: otpauthUrl!, size: 160),
              const SizedBox(height: 8),
              TextField(controller: codeCtrl, decoration: InputDecoration(labelText: t('security.enter_code'))),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final callable = FirebaseFunctions.instance.httpsCallable('verifyTotpEnrollment');
                  await callable.call({'code': codeCtrl.text.trim()});
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('security.enabled'))));
                },
                child: Text(t('security.verify_enable')),
              ),
            ],
            const SizedBox(height: 24),
            TextField(controller: codeCtrl, decoration: InputDecoration(labelText: t('security.code'))),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final callable = FirebaseFunctions.instance.httpsCallable('verifyTotpAndGrantMfa');
                await callable.call({'code': codeCtrl.text.trim()});
                await FirebaseAuth.instance.currentUser?.getIdToken(true);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('security.verified'))));
              },
              child: Text(t('security.verify')),
            ),
          ],
        ),
      ),
    );
  }
}
