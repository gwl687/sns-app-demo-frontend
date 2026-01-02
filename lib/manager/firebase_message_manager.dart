import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageManager {
  static final FirebaseMessageManager instance = FirebaseMessageManager._();

  FirebaseMessageManager._();

  bool initialized = false;
  bool loggedIn = false;

  final StreamController<RemoteMessage> _controller =
      StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get stream => _controller.stream;

  void init() {
    if (initialized) return;
    initialized = true;

    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessage);
  }

  void _onMessage(RemoteMessage msg) {
    print("收到推送: type = ${msg.data['type']}");
    handleMessage(msg);
  }

  void handleMessage(RemoteMessage msg) async {
    _controller.add(msg);
  }
}
