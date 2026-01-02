import 'package:demo10/manager/chat_db_manager.dart';
import 'package:demo10/options/firebase_options.dart';
import 'package:demo10/http/dio_instance.dart';
import 'package:demo10/manager/firebase_message_manager.dart';
import 'package:demo10/pages/auth/auth_vm.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/pages/tab_vm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  DioInstance.instance().initDio(baseUrl: "http://192.168.0.12:8080/");
  //FireBase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, //
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MyApp(),
    ),
  );
}
