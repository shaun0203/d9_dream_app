import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../bloc/dream/dream_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';

class DreamScreen extends StatefulWidget {
  const DreamScreen({super.key});

  @override
  State<DreamScreen> createState() => _DreamScreenState();
}

class _DreamScreenState extends State<DreamScreen> {
  final _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _sttAvailable = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initStt();
  }

  Future<void> _initStt() async {
    _sttAvailable = await _speech.initialize();
    if (mounted) setState(() {});
  }

  void _toggleListen() async {
    if (!_sttAvailable) return;
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }
    setState(() => _isListening = true);
    await _speech.listen(onResult: (result) {
      setState(() => _controller.text = result.recognizedWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze Dream'),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthBloc>().add(AuthEventSignOut()),
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              minLines: 5,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Describe your dream',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      context.read<DreamBloc>().add(DreamEventAnalyze(text));
                    }
                  },
                  icon: const Icon(Icons.psychology_alt),
                  label: const Text('Analyze'),
                ),
                const SizedBox(width: 12),
                if (_sttAvailable)
                  ElevatedButton.icon(
                    onPressed: _toggleListen,
                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                    label: Text(_isListening ? 'Stop' : 'Speak'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<DreamBloc, DreamState>(
                builder: (context, state) {
                  if (state is DreamStateLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is DreamStateSuccess) {
                    final analysis = state.analysis['analysis'] ?? state.analysis;
                    return SingleChildScrollView(
                      child: Text(
                        _formatAnalysis(analysis),
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  if (state is DreamStateFailure) {
                    return Text('Error: ${state.message}', style: const TextStyle(color: Colors.red));
                  }
                  return const Text('Enter or speak your dream to analyze.');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  String _formatAnalysis(Map<String, dynamic> a) {
    final b = StringBuffer();
    if (a['summary'] != null) b.writeln('Summary: ${a['summary']}');
    if (a['themes'] != null) b.writeln('\nThemes: ${(a['themes'] as List).join(', ')}');
    if (a['symbols'] != null) b.writeln('Symbols: ${(a['symbols'] as List).join(', ')}');
    if (a['sentiment'] != null) b.writeln('Sentiment: ${a['sentiment']}');
    if (a['advice'] != null) b.writeln('\nAdvice: ${a['advice']}');
    return b.toString();
  }
}
