import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/pages/Chat/Chat_page.dart';
import 'package:demo10/pages/chat/chat_vm.dart';
import 'package:demo10/pages/chat/group_chat_page.dart';
import 'package:demo10/pages/friend/chat_list_vm.dart';
import 'package:demo10/repository/datas/group_chat_data.dart';
import 'package:demo10/repository/datas/private_chat_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 好友列表页面
class ChatListPage extends StatefulWidget {
  @override
  State createState() {
    return _FriendPage();
  }
}

class _FriendPage extends State<ChatListPage> {
  static List<String> _friends = [];

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void initData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat"), backgroundColor: Colors.green),
      body: Consumer<ChatListViewModel>(
        builder: (context, vm, child) {
          final chatList = vm.chatList;
          return RefreshIndicator(
            onRefresh: () async {
              await vm.load();
            },
            child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final chat = chatList[index];
                if (chat is PrivateChatData) {
                  //是私聊
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(chat.avatarUrl), // 显示首字母
                    ),
                    title: Text(chat.userName),
                    onTap: () async{
                      final myId = await SpUtils.getInt(BaseConstants.SP_User_Id);
                      //点击进入ChatPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                              create: (_) => ChatViewModel(
                                  myId: myId,
                                  friendId: chat.id,
                                  friendAvatarUrl: chat.avatarUrl,
                                  friendName: chat.userName
                              ),
                              child: ChatPage()
                          ),
                        ),
                      );
                    },
                  );
                } else if (chat is GroupChatData) {
                  //是群聊
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(chat.groupName[0]), // 显示首字母
                    ),
                    title: Text(chat.groupName),
                    onTap: () {
                      //点击进入GroupChatPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupChatPage(
                            id: chat.groupId,
                            ownerId: chat.ownerId,
                            memberIds: chat.memberIds,
                            name: chat.groupName,
                            avatarUrl: chat.avatarUrl,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
