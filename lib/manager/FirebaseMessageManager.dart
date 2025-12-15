import 'dart:developer';

import 'package:demo10/pages/social/store/timeline_vm.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageManager {
  static final FirebaseMessageManager instance = FirebaseMessageManager._();

  FirebaseMessageManager._();

  TimelineViewModel timelineViewModel = new TimelineViewModel();

  void handleMessage(RemoteMessage msg) {
    switch (msg.data['type']) {
      case 'gettimeline':
        timelineViewModel.load();
        break;
      default:
        break;
    }
  }
}
