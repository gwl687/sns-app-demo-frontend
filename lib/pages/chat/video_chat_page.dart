import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoChatPage extends StatefulWidget {
  final String livekitUrl = "ws://3.112.54.245:7880";
  final String token;
  final String userName;

  const VideoChatPage({
    super.key,
    required this.token,
    required this.userName,
  });

  @override
  State<VideoChatPage> createState() => _VideoChatPage();
}

class _VideoChatPage extends State<VideoChatPage> {
  late Room room;

  @override
  void initState() {
    super.initState();
    initRoom();
  }

  Future<void> initRoom() async {
    room = Room();
    await [Permission.camera, Permission.microphone].request();

    room.addListener(() {
      setState(() {});
    });

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
    room.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = room.localParticipant;
    final remote = room.remoteParticipants.values.firstOrNull;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Video Chat")),
      body: Column(
        children: [
          /// 远端（占大屏）
          Expanded(
            flex: 3,
            child: remote == null
                ? _buildWaiting()
                : _buildVideo(remote),
          ),

          /// 本地（小屏）
          Expanded(
            flex: 2,
            child: local == null
                ? const SizedBox()
                : _buildVideo(local),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.call_end),
      ),
    );
  }

  Widget _buildWaiting() {
    return const Center(
      child: Text(
        "Waiting for other participant...",
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _buildVideo(Participant participant) {
    final pub = participant.videoTrackPublications
        .where((p) => p.subscribed && !p.muted)
        .firstOrNull;
    final track = pub?.track as VideoTrack?;

    return Stack(
      children: [
        Positioned.fill(
          child: track == null
              ? Container(
            color: Colors.black,
            child: Center(
              child: Text(
                participant.identity,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
              : VideoTrackRenderer(track, fit: VideoViewFit.cover),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: _buildUserName(participant),
        ),
      ],
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
        getDisplayName(participant),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  String getDisplayName(Participant participant) {
    final metadata = participant.metadata;
    if (metadata == null || metadata.isEmpty) {
      return participant.identity;
    }
    try {
      final map = jsonDecode(metadata);
      return map['username'] ?? participant.identity;
    } catch (_) {
      return participant.identity;
    }
  }
}

