import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/chat_db_manager.dart';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/chat/chat_vm.dart';
import 'package:demo10/pages/chat/send_video_request_page.dart';
import 'package:demo10/pages/chat/send_video_request_vm.dart';
import 'package:demo10/pages/chat/video_chat_page.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/repository/datas/user_info_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _lastMessageCount = 0;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> load() async {
    //userInfo = context.read<UserProfileViewModel>().userInfo;
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatViewModel, UserProfileViewModel>(
      builder: (context, vm, vm2, child) {
        /// 消息数量变化就滚到底
        if (vm.privateMessages.length != _lastMessageCount) {
          _lastMessageCount = vm.privateMessages.length;
          _scrollToBottom();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(vm.friendName),
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                icon: const Icon(Icons.videocam),
                onPressed: () {
                  vm.requestVideoCall();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) =>
                            SendVideoRequestViewModel(friendId: vm.friendId),
                        child: const SendVideoRequestPage(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              ///聊天列表
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: vm.privateMessages.length,
                  itemBuilder: (context, index) {
                    final msg = vm.privateMessages[index];
                    final isMe = msg['fromUser'] == vm.myId;
                    final formattedTime = DateFormat(
                      'yyyy-MM-dd HH:mm',
                    ).format(DateTime.parse(msg['time']));

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                  vm.friendAvatarUrl,
                                ),
                              ),
                            ),

                          Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 260,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Colors.green[200]
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  msg['content'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          if (isMe)
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                  vm2.userInfo!.avatarurl,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// ===== 输入框 =====
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "input message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.green),
                      onPressed: () {
                        if (_controller.text.trim().isEmpty) return;

                        vm.sendMessage(_controller.text);
                        _controller.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
