import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_wedding/features/e_card/domain/usecases/create_new_card_use_case.dart';
import 'package:online_wedding/features/e_card/data/repositories/e_card_repository_impl.dart';
import 'package:online_wedding/features/e_card/presentation/pages/create_card_page.dart';
import 'package:online_wedding/features/e_card/presentation/pages/public_card_page.dart';
import 'package:online_wedding/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:online_wedding/features/e_card/presentation/pages/template_library_page.dart';
import 'package:online_wedding/features/e_card/presentation/pages/public_card_slug_page.dart';
import 'package:online_wedding/features/e_card/presentation/pages/design_customization_page.dart';
import 'package:online_wedding/features/e_card/data/repositories/template_repository_impl.dart';
import 'package:online_wedding/features/auth/presentation/pages/sign_in_page.dart';
import 'package:online_wedding/features/subscription/presentation/pages/subscription_page.dart';
import 'package:online_wedding/firebase_options.dart';
import 'package:online_wedding/features/e_card/data/datasources/card_remote_data_source_firestore.dart';

import 'features/e_card/domain/usecases/list_templates_use_case.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirebaseFirestore.instance;
  runApp(
    ProviderScope(
      overrides: [
        eCardRepositoryProvider.overrideWithValue(
          ECardRepositoryImpl(remote: FirestoreCardRemoteDataSource(firestore)),
        ),
        templateRepositoryProvider.overrideWithValue(TemplateRepositoryImpl()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Wedding E-Card',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        final parts = name.split('/').where((e) => e.isNotEmpty).toList();
        if (parts.length == 2 && parts[0] != 'admin') {
          final couple = parts[0];
          final cardId = parts[1];
          return MaterialPageRoute(
            builder: (_) => PublicCardPage(
              coupleName: couple,
              cardId: cardId,
            ),
          );
        }
        if (parts.length == 2 && parts[0] == 'admin') {
          final cardId = parts[1];
          return MaterialPageRoute(
            builder: (_) => AdminDashboardPage(cardId: cardId),
          );
        }
        if (parts.length == 1 && parts[0].isNotEmpty) {
          final slug = parts[0];
          return MaterialPageRoute(
            builder: (_) => PublicCardBySlugPage(slug: slug),
          );
        }
        if (name == '/templates') {
          return MaterialPageRoute(
            builder: (_) => const TemplateLibraryPage(),
          );
        }
        if (name == '/design') {
          return MaterialPageRoute(
            builder: (_) => const DesignCustomizationPage(),
          );
        }
        if (parts.length == 2 && parts[0] == 'design') {
          final cardId = parts[1];
          return MaterialPageRoute(
            builder: (_) => DesignCustomizationPageWithId(cardId: cardId),
          );
        }
        if (name == '/auth') {
          return MaterialPageRoute(
            builder: (_) => const SignInPage(),
          );
        }
        if (name == '/subscription') {
          return MaterialPageRoute(
            builder: (_) => const SubscriptionPage(),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const CreateCardPage(),
        );
      },
    );
  }
}
