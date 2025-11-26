import 'dart:async';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupVideoChatPage extends StatefulWidget {
  final String livekitUrl = "ws://3.112.54.245:7880";
  final String token;

  const GroupVideoChatPage({
    super.key,
    required this.token,
  });

  @override
  State<GroupVideoChatPage> createState() => _GroupVideoChatPageState();
}

class _GroupVideoChatPageState extends State<GroupVideoChatPage> {
  late Room room;

  @override
  void initState() {
    super.initState();
    initRoom();
  }

  /// 初始化房间 + 请求权限
  Future<void> initRoom() async {
    room = Room();
    await [Permission.camera, Permission.microphone].request();

    // 监听成员变化
    room.addListener(() {
      setState(() {});
    });

    // 连接房间
    await room.connect(
      widget.livekitUrl,
      widget.token,
      connectOptions: const ConnectOptions(autoSubscribe: true),
    );

    // 发布本地视频与音频
    await room.localParticipant?.setCameraEnabled(true);
    await room.localParticipant?.setMicrophoneEnabled(true);
  }

  @override
  void dispose() {
    room.disconnect();
    super.dispose();
  }

  Widget _buildVideo(Participant participant) {
    // 获取可用的视频 publication
    final pub = participant.videoTrackPublications
        .where((p) => p.subscribed && !p.muted)
        .firstOrNull;
    final track = pub?.track as VideoTrack?;

    if (track == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Text(
            participant.identity,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return VideoTrackRenderer(track, fit: VideoViewFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final List<Participant> participants = [
      if (room.localParticipant != null) room.localParticipant!,
      ...room.remoteParticipants.values,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Group Video Chat")),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        itemCount: participants.length,
        itemBuilder: (context, index) {
          final participant = participants[index]; // 显式声明类型

          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.hardEdge,
            child: _buildVideo(participant),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.call_end),
      ),
    );
  }
}
