import 'package:firebase_messaging/firebase_messaging.dart';

class PushEventData {
  final RemoteMessage message;
  final bool isBackGround;

  PushEventData(this.message, this.isBackGround);
}