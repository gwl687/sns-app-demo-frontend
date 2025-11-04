import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoChatPage extends StatefulWidget {
  final int myId;
  final int friendId;

  const VideoChatPage({
    Key? key,
    required this.myId,
    required this.friendId,
  }) : super(key: key);

  @override
  State<VideoChatPage> createState() => _VideoChatPageState();
}

class _VideoChatPageState extends State<VideoChatPage> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  @override
  void initState() {
    super.initState();
    _initRenderers();
    _startVideoChat();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection?.close();
    super.dispose();
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _startVideoChat() async {
    // 1. 获取摄像头和麦克风
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });
    _localRenderer.srcObject = _localStream;

    // 2. 创建 PeerConnection
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}, // Google STUN server
      ]
    };

    _peerConnection = await createPeerConnection(config);

    // 3. 添加本地流到 PeerConnection
    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    // 4. 监听远程流
    _peerConnection?.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
      }
    };

    // TODO: 5. 通过 WebSocket 交换 SDP 和 ICE Candidate
    // WebSocketManager.instance.sendCommand(...) 来传递 offer/answer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("视频通话 - ${widget.friendId}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(_remoteRenderer, mirror: true),
          ),
          SizedBox(
            height: 160,
            child: RTCVideoView(_localRenderer, mirror: true),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("挂断"),
          ),
        ],
      ),
    );
  }
}
