import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_wedding/core/localization/localization.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

final _authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final _signInStateProvider = StateProvider<AsyncValue<User?>>((ref) {
  return const AsyncValue.data(null);
});

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final state = ref.watch(_signInStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t('auth.sign_in'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: t('auth.email'))),
            TextField(controller: passCtrl, decoration: InputDecoration(labelText: t('auth.password')), obscureText: true),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                ref.read(_signInStateProvider.notifier).state = const AsyncValue.loading();
                try {
                  final auth = ref.read(_authProvider);
                  final cred = await auth.signInWithEmailAndPassword(email: emailCtrl.text.trim(), password: passCtrl.text);
                  ref.read(_signInStateProvider.notifier).state = AsyncValue.data(cred.user);
                } catch (e, st) {
                  ref.read(_signInStateProvider.notifier).state = AsyncValue.error(e, st);
                }
              },
              child: Text(t('auth.sign_in')),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                ref.read(_signInStateProvider.notifier).state = const AsyncValue.loading();
                try {
                  final auth = ref.read(_authProvider);
                  final cred = await auth.createUserWithEmailAndPassword(
                    email: emailCtrl.text.trim(),
                    password: passCtrl.text,
                  );
                  ref.read(_signInStateProvider.notifier).state = AsyncValue.data(cred.user);
                } catch (e, st) {
                  ref.read(_signInStateProvider.notifier).state = AsyncValue.error(e, st);
                }
              },
              child: Text(t('auth.register')),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                try {
                  final auth = ref.read(_authProvider);
                  if (kIsWeb) {
                    final provider = GoogleAuthProvider();
                    await auth.signInWithPopup(provider);
                  } else {
                    final g = GoogleSignIn();
                    final acc = await g.signIn();
                    if (acc == null) return;
                    final tokens = await acc.authentication;
                    final cred = GoogleAuthProvider.credential(
                      accessToken: tokens.accessToken,
                      idToken: tokens.idToken,
                    );
                    await auth.signInWithCredential(cred);
                  }
                } catch (_) {}
              },
              child: Text(t('auth.google')),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                try {
                  final auth = ref.read(_authProvider);
                  if (kIsWeb) {
                    final provider = FacebookAuthProvider();
                    await auth.signInWithPopup(provider);
                  } else {
                    final result = await FacebookAuth.instance.login();
                    if (result.status == LoginStatus.success) {
                      final token = result.accessToken?.token;
                      if (token != null) {
                        final cred = FacebookAuthProvider.credential(token);
                        await auth.signInWithCredential(cred);
                      }
                    }
                  }
                } catch (_) {}
              },
              child: Text(t('auth.facebook')),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                final auth = ref.read(_authProvider);
                await auth.signOut();
                ref.read(_signInStateProvider.notifier).state = const AsyncValue.data(null);
              },
              child: Text(t('auth.logout')),
            ),
            const SizedBox(height: 12),
            state.when(
              data: (u) => u == null ? const SizedBox.shrink() : Text('${t('auth.hello')} ${u.email ?? ''}'),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('${t('auth.error')}: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
