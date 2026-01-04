import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoChatPage extends StatefulWidget {
  final String token;

  const VideoChatPage({super.key, required this.token});

  @override
  State<VideoChatPage> createState() => _VideoChatPageState();
}

class _VideoChatPageState extends State<VideoChatPage> {
  late Room room;

  bool _hadRemote = false;
  bool _ended = false;

  final String livekitUrl = "ws://3.112.54.245:7880";

  @override
  void initState() {
    super.initState();
    initRoom();
  }

  Future<void> initRoom() async {
    room = Room();

    await [Permission.camera, Permission.microphone].request();

    room.addListener(() {
      if (!mounted || _ended) return;

      final hasRemote = room.remoteParticipants.isNotEmpty;

      if (hasRemote) {
        _hadRemote = true;
      }

      if (_hadRemote && !hasRemote) {
        _ended = true;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("The call has ended")));

        Navigator.pop(context);
        return;
      }

      setState(() {});
    });

    await room.connect(
      livekitUrl,
      widget.token,
      connectOptions: const ConnectOptions(autoSubscribe: true),
    );

    await room.localParticipant?.setCameraEnabled(true);
    await room.localParticipant?.setMicrophoneEnabled(true);
  }

  @override
  void dispose() {
    try {
      room.localParticipant?.setCameraEnabled(false);
      room.localParticipant?.setMicrophoneEnabled(false);
    } catch (_) {}
    room.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = room.localParticipant;
    final remote = room.remoteParticipants.values.firstOrNull;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("视频通话"), backgroundColor: Colors.black),
      body: Stack(
        children: [
          /// 远端：全屏
          Positioned.fill(
            child: remote == null ? _buildWaiting() : _buildVideo(remote),
          ),

          /// 本地：左上角小窗
          if (local != null)
            Positioned(
              top: 16,
              left: 16,
              width: 120,
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.black,
                  child: _buildVideo(local),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.call_end),
      ),
    );
  }

  /// ================= UI =================

  Widget _buildWaiting() {
    return const Center(
      child: Text(
        "connecting…",
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
    );
  }

  Widget _buildVideo(Participant participant) {
    dynamic pub;
    dynamic track;

    // 找一个可用的视频轨道
    for (final p in participant.videoTrackPublications) {
      if (p.subscribed == true && p.muted == false) {
        pub = p;
        track = p.track;
        break;
      }
    }
    // 显示名字
    final String displayName = jsonDecode(participant.metadata!)['username'];

    return Stack(
      fit: StackFit.expand,
      children: [
        /// 视频画面
        if (track != null)
          VideoTrackRenderer(track, fit: VideoViewFit.cover)
        else
          Container(color: Colors.black),

        /// 名字
        Positioned(
          left: 8,
          bottom: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              displayName,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
