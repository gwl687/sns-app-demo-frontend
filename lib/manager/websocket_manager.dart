import 'dart:convert';
import 'dart:io';
import 'package:demo10/app_config.dart';
import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/chat_message_manager.dart';
import 'package:demo10/utils/sp_utils.dart';

class WebsocketManager {
  static final WebsocketManager instance = WebsocketManager._internal();

  WebsocketManager._internal();

  WebSocket? _socket;

  // 新增: 收到消息的回调
  Function(Map<String, dynamic>)? onMessageReceived;

  //各种类型消息的回调
  Function(Map<String, dynamic>)? onPrivateMessage;
  Function(Map<String, dynamic>)? onPublicMessage;
  Function(Map<String, dynamic>)? onChatPageCommandMessage;

  //各种类型页面的回调
  Function(Map<String, dynamic>)? onChatPageMessage;

  //type对应各种receiveMessage方法的map

  Future<void> connect() async {
    if (_socket != null) return;
    String myToken = await SpUtils.getString(BaseConstants.SP_Token);

    try {
      _socket = await WebSocket.connect(
        AppConfig.wsUrl,
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
            data = {'content': message};
          }
          //处理消息
          String methodName = data['type'].contains('_')
              ? data['type'].split('_')[0]
              : data['type'];
          ChatMessageManager.instance.messageHandlers[methodName]!(data);
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
  void sendMessage(String type, int toUser, String content) {
    final msg = {"type": type, "toUser": toUser, "content": content};
    send(jsonEncode(msg));
  }


  void close() {
    _socket?.close();
    _socket = null;
  }
}
