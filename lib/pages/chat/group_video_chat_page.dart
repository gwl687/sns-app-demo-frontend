import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupVideoChatPage extends StatefulWidget {
  final String livekitUrl = "ws://3.112.54.245:7880";
  final String token;
  final String userName;

  const GroupVideoChatPage({
    super.key,
    required this.token,
    required this.userName,
  });

  @override
  State<GroupVideoChatPage> createState() => _GroupVideoChatPageState();
}

class _GroupVideoChatPageState extends State<GroupVideoChatPage> {
  late Room room;
  VoidCallback? _roomListener;

  @override
  void initState() {
    super.initState();
    initRoom();
  }

  /// 初始化房间 + 请求权限
  Future<void> initRoom() async {
    room = Room();
    await [Permission.camera, Permission.microphone].request();

    _roomListener = () {
      if (!mounted) return;
      setState(() {});
    };

    room.addListener(_roomListener!);

    await room.connect(
      widget.livekitUrl,
      widget.token,
      connectOptions: const ConnectOptions(autoSubscribe: true),
    );

    await room.localParticipant?.setCameraEnabled(true);
    await room.localParticipant?.setMicrophoneEnabled(true);
  }


  @override
  void dispose() {
    room.removeListener(_roomListener!);

    room.disconnect();

    super.dispose();
  }


  Widget _buildVideo(Participant participant) {
    final pub = participant.videoTrackPublications
        .where((p) => p.subscribed && !p.muted)
        .firstOrNull;
    final track = pub?.track as VideoTrack?;

    return Stack(
      children: [
        /// 底层：视频或占位
        Positioned.fill(
          child: track == null
              ? Container(color: Colors.black)
              : VideoTrackRenderer(track, fit: VideoViewFit.cover),
        ),

        /// 右下角用户名
        Positioned(right: 8, bottom: 8, child: _buildUserName(participant)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Participant> participants = [
      if (room.localParticipant != null) room.localParticipant!,
      ...room.remoteParticipants.values,
    ];

    return Scaffold(
      backgroundColor: Colors.black,
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

  Widget _buildUserName(Participant participant) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        getDisplayName(participant), // LiveKit 里通常就是 username
        style: const TextStyle(color: Colors.white, fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String getDisplayName(Participant participant) {
    final metadata = participant.metadata;
    if (metadata == null || metadata.isEmpty) {
      return participant.identity; // 兜底
    }

    try {
      final map = jsonDecode(metadata);
      return map['username'] ?? participant.identity;
    } catch (e) {
      return participant.identity;
    }
  }
}
