import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Authenticate to continue'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.read<AuthBloc>().add(AuthEventSignInAnonymously()),
                icon: const Icon(Icons.person),
                label: const Text('Continue Anonymously'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
