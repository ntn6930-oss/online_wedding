import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:online_wedding/core/web/jsify_stub.dart'
    if (dart.library.html) 'package:online_wedding/core/web/jsify_web.dart';


class AdminWebAuthnGatePage extends ConsumerStatefulWidget {
  const AdminWebAuthnGatePage({super.key});
  @override
  ConsumerState<AdminWebAuthnGatePage> createState() => _AdminWebAuthnGatePageState();
}

class _AdminWebAuthnGatePageState extends ConsumerState<AdminWebAuthnGatePage> {
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
      final startCallable = FirebaseFunctions.instance.httpsCallable('startWebAuthnAuthentication');
      final options = (await startCallable.call({})).data;
      final cred = await navigatorCredentialsGet({
        'publicKey': _decodeOptions(options),
      });
      final resp = _serializeAssertion(cred);
      final verifyCallable = FirebaseFunctions.instance.httpsCallable('verifyWebAuthnAuthentication');
      await verifyCallable.call(resp);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => error = '$e');
    }
  }
  Map<String, dynamic> _decodeOptions(Map<String, dynamic> o) {
    Map<String, dynamic> m = Map<String, dynamic>.from(o);
    m['challenge'] = _b64ToBuf(m['challenge']);
    final allows = (m['allowCredentials'] as List?) ?? [];
    m['allowCredentials'] = allows.map((c) {
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
  Map<String, dynamic> _serializeAssertion(Object? cred) {
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
    final authData = resp.authenticatorData;
    final clientJSON = resp.clientDataJSON;
    final signature = resp.signature;
    final userHandle = resp.userHandle;
    final rawId = (c as dynamic).rawId;
    return {
      'id': c.id,
      'rawId': encAny(rawId),
      'type': c.type,
      'response': {
        'authenticatorData': encAny(authData),
        'clientDataJSON': encAny(clientJSON),
        'signature': encAny(signature),
        'userHandle': userHandle != null ? encAny(userHandle) : null,
      },
    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: error == null ? const CircularProgressIndicator() : Text(error!)),
    );
  }
}
