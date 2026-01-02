import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/chat_db_manager.dart';
import 'package:demo10/manager/websocket_manager.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/chat/chat_vm.dart';
import 'package:demo10/pages/chat/video_chat_page.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(vm.friendName),
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                icon: Icon(Icons.videocam),
                onPressed: () {
                  String myName = context.read<UserProfileViewModel>().userInfo!.username;
                  vm.requestVideoCall(myName);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("send video request...")),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: vm.privateMessages.length,
                  itemBuilder: (context, index) {
                    final msg = vm.privateMessages[index];
                    final isMe = msg['fromUser'] == vm.myId!;
                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.green[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(msg['content']),
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
