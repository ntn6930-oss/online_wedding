import 'dart:html' as html;

Object jsifyPublicKeyOptions(Map<String, dynamic> options) {
  return options;
}

Future<html.PublicKeyCredential?> navigatorCredentialsCreate(
  Map<String, dynamic> options,
) async {
  final cred = await html.window.navigator.credentials?.create(options);
  return cred as html.PublicKeyCredential?;
}

Future<html.PublicKeyCredential?> navigatorCredentialsGet(
  Map<String, dynamic> options,
) async {
  final cred = await html.window.navigator.credentials?.get(options);
  return cred as html.PublicKeyCredential?;
}
