import 'package:d9_dream_app/data/api/api_client.dart';
import 'package:d9_dream_app/data/repositories/auth_repository.dart';

class DreamRepository {
  DreamRepository({required this.authRepository, ApiClient? apiClient})
      : _api = apiClient ?? ApiClient();

  final AuthRepository authRepository;
  final ApiClient _api;

  Future<String> analyzeDream(String dream) async {
    final token = await authRepository.getIdToken();
    final res = await _api.post(
      '/v1/dream/analyze',
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      body: {'dream': dream},
    );
    return (res['analysis'] as String?) ?? 'No analysis available.';
  }
}
