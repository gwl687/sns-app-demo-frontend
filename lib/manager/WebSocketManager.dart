import 'dart:convert';
import 'dart:io';

import 'package:demo10/constants.dart';
import 'package:demo10/utils/sp_utils.dart';

class WebSocketManager {
  static final WebSocketManager instance = WebSocketManager._internal();

  WebSocketManager._internal();

  WebSocket? _socket;

  // 新增: 收到消息的回调
  Function(Map<String, dynamic>)? onMessageReceived;

  Future<void> connect() async {
    if (_socket != null) return;
    String myToken = await SpUtils.getString(Constants.SP_Token);

    try {
      _socket = await WebSocket.connect(
        'ws://10.0.2.2:8081/ws',
        headers: {'Authorization': 'Bearer $myToken'},
      );

      _socket!.listen(
        (message) async {
          print("收到消息: $message");
          Map<String, dynamic> data;
          try {
            data = jsonDecode(message);
          } catch (e) {
            print(e);
            print("不是 JSON，作为普通字符串处理: $message");
            data = {'content': message};
          }

          if (onMessageReceived != null) {
            onMessageReceived!(data);
          }
        },
        onDone: () {
          print("WebSocket 关闭");
          _socket = null;
        },
        onError: (error) {
          print("WebSocket 错误: $error");
          _socket = null;
        },
      );

      print("WebSocket 已连接到 Netty 8081");
    } catch (e) {
      print("连接失败: $e");
    }
  }

  void send(String msg) {
    _socket?.add(msg);
  }

  //发消息
  void sendMessage(String toUser, String content) {
    final msg = {"type": "private", "toUser": toUser, "content": content};
    send(jsonEncode(msg));
  }

  //发命令
  void sendCommand(String toUser){
    final msg = {"type": "command", "toUser": toUser};
    send(jsonEncode(msg));
  }

  void close() {
    _socket?.close();
    _socket = null;
  }
}
