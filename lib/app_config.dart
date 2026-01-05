class AppConfig {
  /// 服务器地址
  static const String baseUrl =
  String.fromEnvironment('BASE_URL', defaultValue: 'https://api.example.com');

  /// WebSocket
  static const String wsUrl =
  String.fromEnvironment('WS_URL', defaultValue: 'wss://api.example.com/ws');

  
}