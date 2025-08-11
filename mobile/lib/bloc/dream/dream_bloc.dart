import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../data/repositories/analysis_repository.dart';
import 'dream_event.dart';
import 'dream_state.dart';

class DreamBloc extends Bloc<DreamEvent, DreamState> {
  final AnalysisRepository analysisRepository;
  final stt.SpeechToText _speech = stt.SpeechToText();

  DreamBloc({required this.analysisRepository}) : super(const DreamState()) {
    on<DreamTextChanged>(_onTextChanged);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<SubmitDream>(_onSubmit);
  }

  Future<void> _onTextChanged(DreamTextChanged e, Emitter<DreamState> emit) async {
    emit(state.copyWith(text: e.text));
  }

  Future<void> _onStartListening(StartListening e, Emitter<DreamState> emit) async {
    final available = await _speech.initialize(onStatus: (s) {}, onError: (e) {});
    if (!available) return;
    emit(state.copyWith(listening: true));
    _speech.listen(onResult: (result) {
      add(DreamTextChanged(result.recognizedWords));
    });
  }

  Future<void> _onStopListening(StopListening e, Emitter<DreamState> emit) async {
    await _speech.stop();
    emit(state.copyWith(listening: false));
  }

  Future<void> _onSubmit(SubmitDream e, Emitter<DreamState> emit) async {
    if (state.text.trim().isEmpty) return;
    emit(state.copyWith(loading: true, error: null));
    try {
      final res = await analysisRepository.analyzeDream(state.text.trim());
      emit(state.copyWith(
        loading: false,
        summary: res.summary,
        symbols: res.symbols,
        themes: res.themes,
        advice: res.advice,
      ));
    } catch (err) {
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }
}
