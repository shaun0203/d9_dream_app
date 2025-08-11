class AnalysisResult {
  final String summary;
  final List<String> symbols;
  final List<String> themes;
  final String advice;

  AnalysisResult({
    required this.summary,
    required this.symbols,
    required this.themes,
    required this.advice,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) => AnalysisResult(
        summary: json['summary'] as String? ?? '',
        symbols: (json['symbols'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        themes: (json['themes'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        advice: json['advice'] as String? ?? '',
      );
}
