import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth/auth_bloc.dart';
import 'presentation/pages/dream_input_page.dart';
import 'presentation/pages/login_page.dart';

class DreamApp extends StatelessWidget {
  const DreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Analysis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (state is Authenticated) {
            return const DreamInputPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
