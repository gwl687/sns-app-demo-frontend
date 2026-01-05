import 'package:camera/camera.dart';
import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/chat_message_manager.dart';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/pages/chat/send_video_request_vm.dart';
import 'package:demo10/pages/chat/video_chat_page.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendVideoRequestPage extends StatefulWidget {
  const SendVideoRequestPage({super.key});

  @override
  State<SendVideoRequestPage> createState() => _SendVideoRequestPageState();
}

class _SendVideoRequestPageState extends State<SendVideoRequestPage> {
  CameraController? _controller;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    // 选前置摄像头
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    final controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false, // 发请求阶段一般不开麦
    );

    await controller.initialize();

    if (!mounted) return;

    setState(() {
      _controller = controller;
      _isInitializing = false;
    });
  }

  @override
  void dispose() {
    ChatMessageManager.instance.vedioChatRequestReponse_vm = null;
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SendVideoRequestViewModel>(
      builder: (context, vm, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!context.mounted) return;

          if (vm.status == 1) {
            // 对方接受
            int myId = await SpUtils.getInt(BaseConstants.SP_User_Id) ?? 0;
            String token = await Api.instance.getLivekitToken(myId);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => VideoChatPage(token: token)),
            );
          }

          if (vm.status == 0) {
            // 对方拒绝
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('对方已拒绝视频通话'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pop(context);
          }
        });
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                // === 摄像头预览 ===
                Positioned.fill(
                  child: _isInitializing
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : CameraPreview(_controller!),
                ),
                // 等待提示
                Positioned(
                  top: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(128),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Waiting for the other person to accept the invitation…',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),

                // === 底部取消按钮 ===
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 14,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        vm.cancel();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
