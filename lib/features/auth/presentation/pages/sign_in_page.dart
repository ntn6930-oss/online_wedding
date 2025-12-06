import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final _signInStateProvider = StateProvider<AsyncValue<User?>>((ref) {
  return const AsyncValue.data(null);
});

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final state = ref.watch(_signInStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Mật khẩu'), obscureText: true),
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
              child: const Text('Đăng nhập'),
            ),
            const SizedBox(height: 12),
            state.when(
              data: (u) => u == null ? const SizedBox.shrink() : Text('Xin chào ${u.email ?? ''}'),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Lỗi: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
