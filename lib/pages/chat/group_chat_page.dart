import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/chat_message_manager.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/chat/group_chat_vm.dart';
import 'package:demo10/pages/chat/group_video_chat_page.dart';
import 'package:demo10/pages/friend/add_group_member_page.dart';
import 'package:demo10/pages/tab_page.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupChatPage extends StatefulWidget {
  @override
  State createState() => _GroupChatPage();
}

class _GroupChatPage extends State<GroupChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ChatMessageManager.instance.chatPagePrivateMessage_vm = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GroupChatViewModel, UserProfileViewModel>(
      builder: (context, groupChatVm, userProfileVm, child) {
        return PopScope(
          canPop: false, // 阻止默认返回
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              // 跳转到聊天列表页
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const TabPage(initialIndex: 2),
                ),
                (route) => false,
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(groupChatVm.name),
              backgroundColor: Colors.green,
              actions: [
                IconButton(
                  icon: Icon(Icons.person_add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddGroupMemberPage(
                          groupId: groupChatVm.id,
                          memberIds: groupChatVm.memberIds,
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
                        builder: (_) => AddGroupMemberPage(
                          groupId: groupChatVm.id,
                          memberIds: groupChatVm.memberIds,
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
                    String token = await Api.instance.getLivekitToken(
                      groupChatVm.id,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GroupVideoChatPage(
                          userName: userProfileVm.userInfo!.username,
                          token: token,
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
                  child: Consumer<GroupChatViewModel>(
                    builder: (context, vm, child) {
                      final messages = vm.groupMessages;
                      return ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final int senderId = int.parse(msg['senderId']);
                          final avatarUrl =
                              groupChatVm.avatarUrlMap[msg['senderId']];
                          final formattedTime = DateFormat(
                            'yyyy-MM-dd HH:mm',
                          ).format(DateTime.parse(msg['time']));
                          final bool isMe =
                              senderId == userProfileVm.userInfo!.userId;
                          return Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///左侧头像（别人）
                              if (!isMe)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundImage: NetworkImage(
                                      avatarUrl ??
                                          BaseConstants.DefaultAvatarurl,
                                    ),
                                  ),
                                ),

                              ///消息气泡
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

                              /// 右侧头像（自己）
                              if (isMe)
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundImage: NetworkImage(
                                      userProfileVm.userInfo!.avatarurl,
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
                            hintText: "insert message...",
                            border: InputBorder.none,
                          ),
                          //onSubmitted: _sendMessage,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.green),
                        onPressed: () {
                          final vm = context.read<GroupChatViewModel>();
                          vm.sendGroupMessage(
                            userProfileVm.userInfo!.userId,
                            groupChatVm.id,
                            _controller.text,
                          );
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
      },
    );
  }
}
