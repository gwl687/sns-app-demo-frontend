import 'package:flutter/material.dart';

class VideoChatPage extends StatelessWidget {
  final String myId;
  final String friendId;

  const VideoChatPage({
    required this.myId,
    required this.friendId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("视频通话")),
      body: Center(
        child: Text("这里是视频通话页面（待实现 WebRTC 或其他 SDK）"),
      ),
    );
  }
}
