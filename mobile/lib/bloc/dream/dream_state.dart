import 'package:equatable/equatable.dart';

class DreamState extends Equatable {
  final String text;
  final bool listening;
  final bool loading;
  final String? error;
  final String? summary;
  final List<String> symbols;
  final List<String> themes;
  final String? advice;

  const DreamState({
    this.text = '',
    this.listening = false,
    this.loading = false,
    this.error,
    this.summary,
    this.symbols = const [],
    this.themes = const [],
    this.advice,
  });

  DreamState copyWith({
    String? text,
    bool? listening,
    bool? loading,
    String? error,
    String? summary,
    List<String>? symbols,
    List<String>? themes,
    String? advice,
  }) => DreamState(
        text: text ?? this.text,
        listening: listening ?? this.listening,
        loading: loading ?? this.loading,
        error: error,
        summary: summary ?? this.summary,
        symbols: symbols ?? this.symbols,
        themes: themes ?? this.themes,
        advice: advice ?? this.advice,
      );

  @override
  List<Object?> get props => [text, listening, loading, error, summary, symbols, themes, advice];
}
