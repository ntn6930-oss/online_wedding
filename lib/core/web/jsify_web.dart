import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'package:js/js_util.dart' as js_util;

Object jsifyPublicKeyOptions(Map<String, dynamic> options) {
  return js_util.jsify(options);

}

Future<html.PublicKeyCredential?> navigatorCredentialsCreate(
  Map<String, dynamic> options,
) async {
  final jsOpts = js_util.jsify(options);
  final promise = js_util.callMethod<html.CredentialsContainer>(
    html.window.navigator.credentials!,
    'create',
    [jsOpts],
  );
  final result = await js_util.promiseToFuture(promise);
  return result as html.PublicKeyCredential?;
}

Future<html.PublicKeyCredential?> navigatorCredentialsGet(
  Map<String, dynamic> options,
) async {
  final jsOpts = js_util.jsify(options);
  final promise = js_util.callMethod(
    html.window.navigator.credentials!,
    'get',
    [jsOpts],
  );
  final result = await js_util.promiseToFuture(promise);
  return result as html.PublicKeyCredential?;
}
