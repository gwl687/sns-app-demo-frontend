import 'package:demo10/repository/datas/friendlist_data.dart';
import 'package:flutter/material.dart';

import '../../repository/api.dart';

// 好友数据模型
class Friend {
  final String id;
  final String userName;
  final String avatarUrl;

  Friend({
    required this.id,
    required this.userName,
    required this.avatarUrl,
  });
}

class FriendPage extends StatefulWidget {
  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  List<Friend> friends = [
    Friend(id: '1', userName: 'Alice', avatarUrl: 'https://i.pravatar.cc/150?img=1'),
    Friend(id: '2', userName: 'Bob', avatarUrl: 'https://i.pravatar.cc/150?img=2'),
    Friend(id: '3', userName: 'Charlie', avatarUrl: 'https://i.pravatar.cc/150?img=3'),
  ];
  @override
  void initState() {
    super.initState();
    _loadFriends();
  }
  //获取好友列表,先看缓存，没有就拉远程到缓存
  Future<void> _loadFriends() async {
    print("开始加载好友");
    try {
      FriendlistData data = await Api.instance.getFriendList();
      // 把接口返回的 Data 对象映射成 Friend
      List<Friend> list = data.data?.map((e) {
        return Friend(
          id: e.id.toString(),
          userName: e.userName ?? '未知',
          avatarUrl: 'https://i.pravatar.cc/150?img=${e.id}', // 简单生成头像
        );
      }).toList() ?? [];

      // 刷新界面
      setState(() {
        friends = list;
        print("好友列表长度: ${friends.length}");
      });
    } catch (e) {
      print("加载好友失败: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('好友'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: friends.length,
        separatorBuilder: (context, index) => Divider(height: 0.5),
        itemBuilder: (context, index) {
          final friend = friends[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(friend.avatarUrl),
            ),
            title: Text(friend.userName),
            onTap: () {
              // 点击可以跳转到 ChatPage 或其他页面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(friendName: friend.userName),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 简单聊天页面占位
class ChatPage extends StatelessWidget {
  final String friendName;

  const ChatPage({Key? key, required this.friendName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friendName),
      ),
      body: Center(child: Text("与 $friendName 的聊天页面")),
    );
  }
}
