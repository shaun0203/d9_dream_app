// Centralized environment configuration.
class Env {
  // Default to Android emulator loopback. Override with --dart-define.
  static const backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
}
