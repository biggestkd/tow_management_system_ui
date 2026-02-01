
class ApiSettings {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080');
  static const String uiBaseUrl = "${String.fromEnvironment('UI_BASE_URL', defaultValue: 'http://localhost:56914')}/#";
}
