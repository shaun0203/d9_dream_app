import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/dream_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

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
          if (state is AuthStateAuthenticated) {
            return const DreamScreen();
          }
          if (state is AuthStateLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
