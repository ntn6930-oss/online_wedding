import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:online_wedding/core/localization/localization.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  final String sessionUrl;
  const CheckoutPage({super.key, required this.sessionUrl});
  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  bool tried = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (tried) return;
      tried = true;
      final uri = Uri.parse(widget.sessionUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    });
  }
  @override
  Widget build(BuildContext context) {
    final t = ref.watch(tProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t('checkout.title'))),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t('checkout.info')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(widget.sessionUrl);
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              child: Text(t('checkout.open')),
            ),
          ],
        ),
      ),
    );
  }
}

