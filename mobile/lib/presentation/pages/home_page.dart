import 'package:d9_dream_app/bloc/auth/auth_bloc.dart';
import 'package:d9_dream_app/bloc/dream/dream_bloc.dart';
import 'package:d9_dream_app/data/repositories/dream_repository.dart';
import 'package:d9_dream_app/presentation/widgets/dream_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DreamBloc(context.read<DreamRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dream Analysis'),
          actions: [
            IconButton(
              onPressed: () => context.read<AuthBloc>().add(AuthSignOutRequested()),
              icon: const Icon(Icons.logout),
              tooltip: 'Sign out',
            ),
          ],
        ),
        body: const DreamInput(),
      ),
    );
  }
}
