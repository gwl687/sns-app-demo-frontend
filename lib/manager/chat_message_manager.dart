import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/manager/chat_db_manager.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/repository/datas/private_message_data.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/cupertino.dart';

class ChatMessageManager {
  static final ChatMessageManager instance = ChatMessageManager._instance();

  ChatMessageManager._instance() {
    messageHandlers = {
      //私聊消息
      "private": privateMessage,
      //群聊消息
      "group": groupMessage,
      //私人视频通话请求
      "videochatrequest": vedioChatRequest,
      //私人视频通话发起方请求取消
      "videochatrequestcancel": vedioChatRequestCancel,
      //对方对视频请求的回复
      "videochatrequestresponse": vedioChatRequestResponse,
      //对方挂断
      //"videochatcancel": videoChatCancel,
    };
  }

  Map<String, Function(Map<String, dynamic>)> messageHandlers = {};

  //局部vm消息处理
  //收到私聊消息
  void Function(int fromUser, int toUser)? chatPagePrivateMessage_vm = null;

  //收到群聊消息
  void Function(int groupId)? receiveGroupMessage_vm = null;

  //私人视频通话请求
  void Function(int fromUser, String fromUserName)? vedioChatRequest_vm = null;

  //私人视频通话请求取消
  void Function()? vedioChatRequestCancel_vm = null;

  //对方接受或拒绝了我的视频请求
  void Function(int fromUser, int accept)? vedioChatRequestReponse_vm = null;

  //对方挂断
  void Function()? videoChatCancel_vm = null;

  //全局消息处理
  //收到私聊消息
  void privateMessage(Map<String, dynamic> data) async {
    final int fromUser = data['fromUser'];
    final String content = data['content'];
    final int toUser = await SpUtils.getInt(BaseConstants.SP_User_Id) ?? 0;
    //保存到本地数据库
    await ChatDbManager.insertMessage(fromUser, toUser, content);
    print("保存到本地:fromUser=${fromUser},toUser=${toUser}");
    //当前页面为聊天页面,调用聊天页面的收消息方法
    if (chatPagePrivateMessage_vm != null) {
      chatPagePrivateMessage_vm!(fromUser, toUser);
    }
  }

  //收到群聊消息
  void groupMessage(Map<String, dynamic> data) async {
    final int fromUser = data['fromUser'];
    final int toUser = data['toUser'];
    final String content = data['content'].toString();
    //保存到本地数据库
    await ChatDbManager.insertGroupMessage(fromUser, toUser, content);
    //当前页面为聊天页面,调用聊天页面的收消息方法
    if (receiveGroupMessage_vm != null) {
      receiveGroupMessage_vm!(toUser);
    }
    print("收到群聊消息: $data");
  }

  //收到视频通话请求消息
  void vedioChatRequest(Map<String, dynamic> data) async {
    final int fromUser = data['fromUser'];
    final String fromUserName = data['content'];
    if (vedioChatRequest_vm != null) {
      vedioChatRequest_vm!(fromUser, fromUserName);
    }
  }

  //发起方取消了视频请求
  void vedioChatRequestCancel(Map<String, dynamic> data) async {
    if (vedioChatRequestCancel_vm != null) {
      vedioChatRequestCancel_vm!();
    }
  }

  //对方对视频请求的回复
  void vedioChatRequestResponse(Map<String, dynamic> data) async {
    final int fromUser = data['fromUser'];
    final int accept = int.parse(data['content']);
    //accept=1,接受
    if (vedioChatRequestReponse_vm != null) {
      vedioChatRequestReponse_vm!(fromUser, accept);
    }
  }

  //对方挂断
  void videoChatCancel(Map<String, dynamic> data) async {
    if (videoChatCancel_vm != null) {
      videoChatCancel_vm!();
    }
  }

  //群里有人加入多人视频通话
  void joingroupvideochat(Map<String, dynamic> data) async {}

  //加载进本地sql
  Future<void> loadMessages() async {
    //简单处理，登录时先清空本地数据
    await ChatDbManager.deleteFromTable("group_messages");
    await ChatDbManager.deleteFromTable("messages");
    //私聊
    List<PrivateMessageData> privateMessages = await Api.instance
        .getPrivateMessages();
    for (final msg in privateMessages) {
      DateTime localTime = msg.createTime.toLocal();
      await ChatDbManager.insertMessage(
        msg.senderId,
        msg.receiverId,
        msg.content,
        createTime: localTime.toIso8601String(),
      );
    }
    //群聊
  }
}
