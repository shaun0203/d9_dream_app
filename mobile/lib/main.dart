import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/dream/dream_bloc.dart';
import 'data/repositories/analysis_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');

  // Initialize Firebase using generated options.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final analysisRepository = AnalysisRepository(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000');

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthBloc()..add(AppStarted())),
      BlocProvider(create: (_) => DreamBloc(analysisRepository: analysisRepository)),
    ],
    child: const DreamApp(),
  ));
}
