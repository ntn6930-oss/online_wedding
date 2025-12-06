import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:online_wedding/core/localization/localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/core/web/jsify_stub.dart'
    if (dart.library.html) 'package:online_wedding/core/web/jsify_web.dart';

class WebAuthnRegisterPage extends ConsumerStatefulWidget {
  const WebAuthnRegisterPage({super.key});
  @override
  ConsumerState<WebAuthnRegisterPage> createState() => _WebAuthnRegisterPageState();
}

class _WebAuthnRegisterPageState extends ConsumerState<WebAuthnRegisterPage> {
  String? error;
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      Future.microtask(_run);
    } else {
      setState(() => error = 'WebAuthn requires web browser');
    }
  }
  Future<void> _run() async {
    try {
      final startCallable = FirebaseFunctions.instance.httpsCallable('startWebAuthnRegistration');
      final options = (await startCallable.call({})).data;
      final cred = await navigatorCredentialsCreate({
        'publicKey': _decodeOptions(options),
      });
      final resp = _serializeAttestation(cred);
      final verifyCallable = FirebaseFunctions.instance.httpsCallable('verifyWebAuthnRegistration');
      await verifyCallable.call(resp);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => error = '$e');
    }
  }
  Map<String, dynamic> _decodeOptions(Map<String, dynamic> o) {
    Map<String, dynamic> m = Map<String, dynamic>.from(o);
    m['challenge'] = _b64ToBuf(m['challenge']);
    m['user'] = Map<String, dynamic>.from(m['user']);
    final uid = m['user']['id'];
    if (uid is String) {
      m['user']['id'] = _b64ToBuf(uid);
    }
    final excludes = (m['excludeCredentials'] as List?) ?? [];
    m['excludeCredentials'] = excludes.map((c) {
      final cm = Map<String, dynamic>.from(c);
      cm['id'] = _b64ToBuf(cm['id']);
      return cm;
    }).toList();
    return m;
  }
  ByteBuffer _b64ToBuf(String s) {
    String t = s.replaceAll('-', '+').replaceAll('_', '/');
    while (t.length % 4 != 0) {
      t += '=';
    }
    final bytes = base64.decode(t);
    return Uint8List.fromList(bytes).buffer;
  }
  Map<String, dynamic> _serializeAttestation(Object? cred) {
    final c = cred as html.PublicKeyCredential;
    String encAny(dynamic x) {
      if (x is ByteBuffer) {
        return base64Url.encode(Uint8List.view(x));
      }
      if (x is ByteData) {
        return base64Url.encode(x.buffer.asUint8List());
      }
      if (x is Uint8List) {
        return base64Url.encode(x);
      }
      if (x is List<int>) {
        return base64Url.encode(Uint8List.fromList(x));
      }
      return base64Url.encode(utf8.encode(x.toString()));
    }
    final resp = (c as dynamic).response;
    final attObj = resp.attestationObject;
    final clientJSON = resp.clientDataJSON;
    final rawId = (c as dynamic).rawId;
    return {
      'id': c.id,
      'rawId': encAny(rawId),
      'type': c.type,
      'response': {
        'attestationObject': encAny(attObj),
        'clientDataJSON': encAny(clientJSON),
      },
    };
  }
  @override
  Widget build(BuildContext context) {
    final t = ref.watch(tProvider);
    return Scaffold(
      appBar: AppBar(title: Text('WebAuthn')),
      body: Center(child: error == null ? const CircularProgressIndicator() : Text(error!)),
    );
  }
}
