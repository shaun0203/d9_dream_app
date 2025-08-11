import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'repositories/auth_repository.dart';
import 'repositories/dream_repository.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/dream/dream_bloc.dart';

// NOTE: Run `flutterfire configure` to generate firebase_options.dart
// ignore: uri_does_not_exist
import 'firebase_options.dart' as fo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: fo.DefaultFirebaseOptions.currentPlatform);

  final authRepository = AuthRepository();
  final dreamRepository = DreamRepository();

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider.value(value: authRepository),
      RepositoryProvider.value(value: dreamRepository),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)..add(AuthEventAppStarted())),
        BlocProvider(create: (_) => DreamBloc(authRepository, dreamRepository)),
      ],
      child: const App(),
    ),
  ));
}
