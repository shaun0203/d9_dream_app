import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:d9_dream_app/bloc/auth/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthSignInEmailRequested(_emailCtrl.text.trim(), _passCtrl.text));
                  },
                  child: const Text('Sign In / Register'),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.read<AuthBloc>().add(AuthSignInAnonRequested()),
              child: const Text('Continue as Guest'),
            )
          ],
        ),
      ),
    );
  }
}
