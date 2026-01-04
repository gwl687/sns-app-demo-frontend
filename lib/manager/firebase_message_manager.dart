import 'dart:async';
import 'package:demo10/repository/datas/push_event_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageManager {
  static final FirebaseMessageManager instance = FirebaseMessageManager._();

  FirebaseMessageManager._();

  bool initialized = false;
  bool loggedIn = false;

  final StreamController<PushEventData> _controller =
      StreamController<PushEventData>.broadcast();

  Stream<PushEventData> get stream => _controller.stream;

  void init() {
    if (initialized) return;
    initialized = true;

    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenedMessage);
  }

  //前台
  void _onMessage(RemoteMessage msg) {
    print("收到推送: type = ${msg.data['type']}");
    _controller.add(PushEventData(msg, false));
  }

  //后台
  void _onOpenedMessage(RemoteMessage msg) {
    print("收到推送: type = ${msg.data['type']}");
    _controller.add(PushEventData(msg, true));
  }

}
