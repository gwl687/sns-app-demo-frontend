import 'package:demo10/manager/LoginSuccessManager.dart';
import 'package:demo10/manager/MessageReceiveManager.dart';
import 'package:demo10/pages/chat/groupChat_vm.dart';
import 'package:demo10/pages/chat/groupVideoChat_page.dart';
import 'package:demo10/pages/chat/userProfile_vm.dart';
import 'package:demo10/pages/friend/addGroupMember_page.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/repository/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupChatPage extends StatefulWidget {
  final int id;
  int ownerId;
  List<int> memberIds;
  String name;
  String avatarUrl;

  //final String friendName;

  GroupChatPage({
    required this.id,
    required this.ownerId,
    required this.memberIds,
    required this.name,
    required this.avatarUrl,
  });

  @override
  State createState() => _GroupChatPage();
}

class _GroupChatPage extends State<GroupChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    context.read<GroupChatViewModel>().load(widget.id);
    widget.memberIds.forEach(
      (userId) => context.read<UserProfileViewModel>().load(userId),
    );
    super.initState();
  }

  @override
  void dispose() {
    MessageReceiveManager.instance.chatPagePrivateMessage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 阻止默认返回
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // 跳转到主页(朋友聊天)
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const TabPage(initialIndex: 2)),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddGroupMember(
                      groupId: widget.id,
                      memberIds: widget.memberIds,
                      isAdd: true,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person_remove),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddGroupMember(
                      groupId: widget.id,
                      memberIds: widget.memberIds,
                      isAdd: false,
                    ),
                  ),
                );
              },
            ),
            //vediochat
            IconButton(
              icon: Icon(Icons.camera_front),
              onPressed: () async {
                String token = await Api.instance.getLivekitToken(widget.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupVideoChatPage(token: token),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<GroupChatViewModel>(
                builder: (context, vm, child) {
                  final messages = vm.groupMessages;
                  return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final int fromUserId = int.parse(msg['fromUser']);
                      final bool isMe = fromUserId == vm.myId;
                      return Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 左侧头像（别人）
                          if (!isMe)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Consumer<UserProfileViewModel>(
                                builder: (context, avatarVm, child) {
                                  final avatarUrl = avatarVm.getAvatar(
                                    fromUserId,
                                  );
                                  return CircleAvatar(
                                    radius: 18,
                                    backgroundImage: NetworkImage(avatarUrl!),
                                  );
                                },
                              ),
                            ),

                          // 消息气泡
                          Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.65,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.green[200]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(msg['content']),
                          ),

                          // 右侧头像（自己）
                          if (isMe)
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                  LoginSuccessManager.instance.avatarFileUrl!,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
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
                        hintText: "输入消息...",
                        border: InputBorder.none,
                      ),
                      //onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.green),
                    onPressed: () {
                      final vm = context.read<GroupChatViewModel>();
                      vm.sendGroupMessage(vm.myId, widget.id, _controller.text);
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
