import 'dart:convert';
import 'package:http/http.dart' as http;

class DreamRepository {
  // Replace with your backend URL
  final String baseUrl = const String.fromEnvironment('BACKEND_URL', defaultValue: 'http://localhost:8000');

  Future<Map<String, dynamic>> analyzeDream(String text, {required String token}) async {
    final uri = Uri.parse('$baseUrl/api/v1/dreams/analyze');
    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'text': text, 'language': 'en'}),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Analysis failed: ${resp.statusCode} ${resp.body}');
  }
}
