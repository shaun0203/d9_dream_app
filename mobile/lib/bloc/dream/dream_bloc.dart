import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:d9_dream_app/data/repositories/dream_repository.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:stream_transform/stream_transform.dart';

part 'dream_event.dart';
part 'dream_state.dart';

class DreamBloc extends Bloc<DreamEvent, DreamState> {
  DreamBloc(this._dreamRepository) : super(const DreamState()) {
    on<DreamTextChanged>(_onTextChanged, transformer: _debounce());
    on<DreamSubmitted>(_onSubmitted);
    on<DreamListeningToggled>(_onListeningToggled);
  }

  final DreamRepository _dreamRepository;
  final stt.SpeechToText _speech = stt.SpeechToText();

  FutureOr<void> _onTextChanged(DreamTextChanged event, Emitter<DreamState> emit) {
    emit(state.copyWith(dreamText: event.text));
  }

  Future<void> _onSubmitted(DreamSubmitted event, Emitter<DreamState> emit) async {
    if (state.dreamText.trim().isEmpty) return;
    emit(state.copyWith(status: DreamStatus.submitting, error: null));
    try {
      final analysis = await _dreamRepository.analyzeDream(state.dreamText);
      emit(state.copyWith(status: DreamStatus.success, analysis: analysis));
    } catch (e) {
      emit(state.copyWith(status: DreamStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onListeningToggled(DreamListeningToggled event, Emitter<DreamState> emit) async {
    if (!state.listening) {
      final available = await _speech.initialize();
      if (!available) return;
      emit(state.copyWith(listening: true));
      _speech.listen(onResult: (res) {
        add(DreamTextChanged(res.recognizedWords));
      });
    } else {
      _speech.stop();
      emit(state.copyWith(listening: false));
    }
  }

  EventTransformer<E> _debounce<E>() {
    return (events, mapper) => events.debounce(const Duration(milliseconds: 150)).asyncExpand(mapper);
  }
}
