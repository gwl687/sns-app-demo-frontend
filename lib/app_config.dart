///本地开发
class AppConfig {
  /// 服务器
  static const String baseUrl =
  String.fromEnvironment('BASE_URL', defaultValue: 'http://192.168.0.12:8080/');

  /// WebSocket
  static const String wsUrl =
  String.fromEnvironment('WS_URL', defaultValue: 'ws://192.168.0.12:8081/ws');

}