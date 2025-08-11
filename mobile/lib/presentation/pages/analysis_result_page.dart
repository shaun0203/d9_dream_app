import 'package:flutter/material.dart';

import '../../bloc/dream/dream_state.dart';

class AnalysisResultPage extends StatelessWidget {
  final DreamState state;
  const AnalysisResultPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Result')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(state.summary ?? ''),
            const SizedBox(height: 16),
            Text('Themes', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: state.themes.map((t) => Chip(label: Text(t))).toList()),
            const SizedBox(height: 16),
            Text('Symbols', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: state.symbols.map((s) => Chip(label: Text(s))).toList()),
            const SizedBox(height: 16),
            Text('Advice', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(state.advice ?? ''),
          ],
        ),
      ),
    );
  }
}
