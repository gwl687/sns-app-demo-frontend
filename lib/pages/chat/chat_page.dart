import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/chat_db_manager.dart';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/chat/chat_vm.dart';
import 'package:demo10/pages/chat/send_video_request_page.dart';
import 'package:demo10/pages/chat/send_video_request_vm.dart';
import 'package:demo10/pages/chat/video_chat_page.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, vm, child) {
        String myAvatarUrl = context
            .read<UserProfileViewModel>()
            .userInfo!
            .avatarurl;
        return Scaffold(
          appBar: AppBar(
            title: Text(vm.friendName),
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                icon: Icon(Icons.videocam),
                onPressed: () async {
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
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.all(8),
                  itemCount: vm.privateMessages.length,
                  itemBuilder: (context, index) {
                    final msg = vm.privateMessages[
                    vm.privateMessages.length - 1 - index];
                    final isMe = msg['fromUser'] == vm.myId!;
                    final String formattedTime = DateFormat(
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
                          // 左侧头像（对方）
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

                          // 气泡 + 时间
                          Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              // 气泡
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
                              // 时间
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          // 右侧头像（自己）
                          if (isMe)
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(myAvatarUrl),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "input message...",
                          border: InputBorder.none,
                        ),
                        //onSubmitted: _sendMessage,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.green),
                      onPressed: () {
                        vm.sendMessage(_controller.text);
                        _controller.clear();
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          );
                        }
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
