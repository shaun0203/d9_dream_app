import 'package:d9_dream_app/bloc/dream/dream_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DreamInput extends StatefulWidget {
  const DreamInput({super.key});

  @override
  State<DreamInput> createState() => _DreamInputState();
}

class _DreamInputState extends State<DreamInput> {
  final _ctrl = TextEditingController();
  final _tts = FlutterTts();
  bool _ttsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DreamBloc, DreamState>(
      listener: (context, state) async {
        if (state.status == DreamStatus.success && _ttsEnabled) {
          await _tts.stop();
          await _tts.speak(state.analysis);
        }
      },
      builder: (context, state) {
        _ctrl.value = _ctrl.value.copyWith(
          text: state.dreamText,
          selection: TextSelection.collapsed(offset: state.dreamText.length),
        );
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _ctrl,
                decoration: const InputDecoration(
                  labelText: 'Describe your dream...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                onChanged: (v) => context.read<DreamBloc>().add(DreamTextChanged(v)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: state.status == DreamStatus.submitting
                        ? null
                        : () => context.read<DreamBloc>().add(DreamSubmitted()),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Analyze'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.tonalIcon(
                    onPressed: () => context.read<DreamBloc>().add(DreamListeningToggled()),
                    icon: Icon(state.listening ? Icons.mic : Icons.mic_none),
                    label: Text(state.listening ? 'Listening...' : 'Speak'),
                  ),
                  const Spacer(),
                  Row(children: [
                    const Text('TTS'),
                    Switch(value: _ttsEnabled, onChanged: (v) => setState(() => _ttsEnabled = v)),
                  ])
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Analysis', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        if (state.status == DreamStatus.submitting) const LinearProgressIndicator(),
                        if (state.status == DreamStatus.failure)
                          Text(state.error ?? 'Unknown error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        if (state.analysis.isNotEmpty) Text(state.analysis),
                        if (state.analysis.isEmpty && state.status == DreamStatus.idle)
                          const Text('Your analysis will appear here.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
