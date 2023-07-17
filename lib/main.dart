import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_logger/simple_logger.dart';

import 'firebase_options.dart';

part 'main.g.dart';

late final FirebaseApp firebaseApp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.userChanges().first;

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase SAML Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SAMLSample(),
    );
  }
}

class SAMLSample extends ConsumerWidget {
  const SAMLSample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);
    return authController.when(
      data: (data) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (data == null)
                    ElevatedButton(
                      onPressed: () async => await ref
                          .read(authControllerProvider.notifier)
                          .samlSignIn(),
                      child: const Text('SAML Sign In'),
                    ),
                  if (data != null) ...[
                    const Text('Firebase SAML Sign-in SUCCESS!!!',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    SelectableText('Email: ${data.email!}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    SelectableText('Uid: ${data.uid}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async => await ref
                          .read(authControllerProvider.notifier)
                          .samlSignOut(),
                      child: const Text('Sign Out'),
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stack) {
        logger.severe(error);
        logger.severe(stack);
        return Scaffold(
          body: Text(
            error.toString(),
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

@riverpod
SAMLAuthProvider samlAuth(SamlAuthRef ref) {
  return SAMLAuthProvider('saml.saml-provider');
}

@riverpod
class AuthController extends _$AuthController {
  final _auth = FirebaseAuth.instance;

  @override
  FutureOr<User?> build() async {
    _auth.userChanges().listen((user) {
      state = AsyncValue.data(user);
    });

    return state.value;
  }

  Future<void> samlSignIn() async {
    state = const AsyncLoading<User?>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final userCredential = await FirebaseAuth.instanceFor(app: firebaseApp)
          .signInWithPopup(ref.read(samlAuthProvider));
      return userCredential.user;
    });
  }

  Future<void> samlSignOut() async {
    state = const AsyncLoading<User?>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      await FirebaseAuth.instance.signOut();
      return null;
    });
  }
}

final logger = SimpleLogger()
  ..setLevel(
    Level.ALL,
    includeCallerInfo: true,
  );
