import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/dream/dream_bloc.dart';
import '../../bloc/dream/dream_event.dart';
import '../../bloc/dream/dream_state.dart';
import 'analysis_result_page.dart';

class DreamInputPage extends StatelessWidget {
  const DreamInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Describe your dream'),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthBloc>().add(SignOutRequested()),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: BlocConsumer<DreamBloc, DreamState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (state.summary != null) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AnalysisResultPage(state: state)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  minLines: 5,
                  maxLines: 12,
                  onChanged: (v) => context.read<DreamBloc>().add(DreamTextChanged(v)),
                  decoration: InputDecoration(
                    hintText: 'Type your dream... or use the mic below',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: state.listening
                          ? () => context.read<DreamBloc>().add(StopListening())
                          : () => context.read<DreamBloc>().add(StartListening()),
                      icon: Icon(state.listening ? Icons.mic : Icons.mic_none),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: state.loading ? null : () => context.read<DreamBloc>().add(SubmitDream()),
                    icon: state.loading
                        ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.send),
                    label: const Text('Analyze'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
