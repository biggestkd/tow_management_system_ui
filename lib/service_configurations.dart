
class ApiSettings {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080');
  static const String domainBaseUrl = String.fromEnvironment('DOMAIN_BASE_URL', defaultValue: 'http://localhost:3000');
}
