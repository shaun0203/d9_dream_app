part of 'dream_bloc.dart';

enum DreamStatus { idle, submitting, success, failure }

class DreamState extends Equatable {
  const DreamState({
    this.dreamText = '',
    this.analysis = '',
    this.status = DreamStatus.idle,
    this.listening = false,
    this.error,
  });

  final String dreamText;
  final String analysis;
  final DreamStatus status;
  final bool listening;
  final String? error;

  DreamState copyWith({
    String? dreamText,
    String? analysis,
    DreamStatus? status,
    bool? listening,
    String? error,
  }) => DreamState(
        dreamText: dreamText ?? this.dreamText,
        analysis: analysis ?? this.analysis,
        status: status ?? this.status,
        listening: listening ?? this.listening,
        error: error,
      );

  @override
  List<Object?> get props => [dreamText, analysis, status, listening, error];
}
