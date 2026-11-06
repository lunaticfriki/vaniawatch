final class ApiConfig {
  const ApiConfig._({required this.baseUrl, required this.userId});

  factory ApiConfig.create({required String baseUrl, required String userId}) =>
      ApiConfig._(baseUrl: Uri.parse(baseUrl), userId: userId);

  factory ApiConfig.fromEnvironment() =>
      ApiConfig.create(baseUrl: _baseUrl, userId: _userId);

  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8080',
  );
  static const String _userId = String.fromEnvironment(
    'USER_ID',
    defaultValue: '00000000-0000-4000-8000-000000000001',
  );

  final Uri baseUrl;
  final String userId;

  Uri uri(String path) => baseUrl.resolve(path);
}
