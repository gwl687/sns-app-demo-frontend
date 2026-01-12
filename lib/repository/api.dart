import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:demo10/repository/datas/group_chat_data.dart';
import 'package:demo10/repository/datas/group_message_data.dart';
import 'package:demo10/repository/datas/login_data.dart';
import 'package:demo10/repository/datas/private_chat_data.dart';
import 'package:demo10/repository/datas/private_message_data.dart';
import 'package:demo10/repository/datas/timeline/timline_post_data.dart';
import 'package:demo10/repository/datas/user/search_for_user_data.dart';
import 'package:demo10/repository/datas/user/user_info_data.dart';
import 'package:demo10/repository/datas/user/user_login_data.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import '../http/dio_instance.dart';
import 'package:mime/mime.dart';

class Api {
  static Api instance = Api._();

  Api._();

  ///发送验证码
  Future<dynamic> sendVerificationCode(String emailaddress) async {
    await DioInstance.instance().post(
      path: "/api/user/sendverificationcode",
      queryParameters: {"emailaddress": emailaddress},
    );
  }

  ///注册
  Future<bool> register(
    String emailaddress,
    String verificationCode,
    String password,
  ) async {
    Response response = await DioInstance.instance().post(
      path: "/api/user/register",
      data: {
        "emailaddress": emailaddress,
        "password": password,
        "verificationCode": verificationCode,
      },
    );
    return response.data['code'] == 1;
  }

  ///登录
  Future<UserLoginData> login({
    String? emailaddress,
    String? password,
    String? pushToken,
  }) async {
    Response response = await DioInstance.instance().post(
      path: "/api/user/login",
      data: {
        "emailaddress": emailaddress,
        "password": password,
        "pushToken": pushToken,
      },
    );
    return UserLoginData.fromJson(response.data['data']);
  }

  ///google登录
  Future<UserLoginData> googleLogin(
    String? idTokenString,
    String? pushToken,
  ) async {
    Response response = await DioInstance.instance().post(
      path: "/api/user/googlelogin",
      data: {"idTokenString": idTokenString, "pushToken": pushToken},
    );
    return UserLoginData.fromJson(response.data['data']);
  }

  ///改名
  Future<void> changeUserName(String newUserName) async {
    Response response = await DioInstance.instance().post(
      path: "/api/user/changeusername",
      queryParameters: {"newUsername": newUserName},
    );
  }

  ///获取好友列表
  Future<List<UserInfoData>> getFriendList() async {
    Response response = await DioInstance.instance().get(
      path: "/api/friend/getfriendlist",
    );
    final List list = response.data['data'];
    return list.map((e) => UserInfoData.fromJson(e)).toList();
  }

  ///点击好友列表名字后添加到好友聊天列表
  Future<void> addToChatList(int friendId) async {
    await DioInstance.instance().post(
      path: "/api/friend/addtochatlist",
      queryParameters: {"friendId": friendId},
    );
  }

  ///建群
  Future<GroupChatData> createGroupChat(List<int> selectedFriends) async {
    Response response = await DioInstance.instance().post(
      path: "/api/group/creategroupchat",
      data: {"selectedFriends": selectedFriends},
    );
    //
    print("创建群聊: ${response.data['data']}");
    GroupChatData groupChatData = GroupChatData.fromJson(response.data['data']);

    return groupChatData;
  }

  ///获取群信息
  Future<GroupChatData> getGroupChat(int groupId) async {
    Response response = await DioInstance.instance().get(
      path: "/api/user/getgroupchat",
      param: {'groupId': groupId},
    );
    //
    print("获取群聊信息: ${response.data}");
    return GroupChatData.fromJson(response.data);
  }

  ///获取聊天列表
  Future<List<dynamic>> getChatList() async {
    Response response = await DioInstance.instance().get(
      path: "/api/friend/getchatlist",
    );
    List<dynamic> result = [];
    (response.data['data'] as List).forEach((e) {
      if (e != null) {
        if (e['id'] != null) {
          result.add(PrivateChatData.fromJson(e));
        } else {
          result.add(GroupChatData.fromJson(e));
        }
      }
    });
    return result;
  }

  ///获得私聊消息
  Future<List<PrivateMessageData>> getPrivateMessages() async {
    Response response = await DioInstance.instance().get(
      path: "/api/chatmessage/getprivatemessages",
    );
    final List list = response.data['data'];
    return list.map((e) => PrivateMessageData.fromJson(e)).toList();
  }

  ///发送群消息
  Future<void> saveGroupMessage(GroupMessageData groupMessageData) async {
    Response response = await DioInstance.instance().post(
      path: "/api/group/saveGroupMessage",
      queryParameters: {'groupMessageDTO': groupMessageData},
    );
    print("保存聊天消息到后端: ${response.data}");
  }

  ///获得群聊天消息
  Future<List<GroupMessageData>> getGroupMessages() async {
    Response response = await DioInstance.instance().get(
      path: "/api/chatmessage/getgroupmessages",
    );
    final List list = response.data['data'];
    return list.map((e) => GroupMessageData.fromJson(e)).toList();
  }

  ///获取当前登录用户数据
  Future<UserInfoData> getUserInfo() async {
    Response response = await DioInstance.instance().get(
      path: "/api/user/getuserinfo",
    );
    return UserInfoData.fromJson(response.data['data']);
  }

  ///更新当前登录用户数据
  Future<bool> updateUserInfo(UserInfoData userInfoData) async {
    Response response = await DioInstance.instance().post(
      path: "/api/user/updateuserinfo",
      queryParameters: {'updateUserInfoDTO': userInfoData},
    );
    return response.data['data'];
  }

  ///获取指定用户数据
  Future<UserInfoData> getUserInfoById(int userId) async {
    Response response = await DioInstance.instance().get(
      path: "/api/user/getuserinfobyid",
      param: {"userId": userId},
    );
    return UserInfoData.fromJson(response.data['data']);
  }

  ///上传头像到s3
  Future<bool> uploadAvatar(String filePath, String fileName) async {
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: DioMediaType.parse(mimeType),
      ),
    });
    Response response = await DioInstance.instance().put(
      path: "/api/user/uploadavatar",
      data: formData,
    );
    return response.data['data'];
  }

  ///添加群成员
  Future<bool> addGroupMembers(int groupId, List<int> selectedFriends) async {
    Response response = await DioInstance.instance().post(
      path: "/api/group/addgroupmembers",
      data: {"groupId": groupId, "selectedFriends": selectedFriends},
    );
    return response.data['data'];
  }

  ///移除群成员
  Future<bool> removeGroupMembers(
    int groupId,
    List<int> selectedFriends,
  ) async {
    Response response = await DioInstance.instance().post(
      path: "/api/group/removegroupmembers/$groupId",
      data: {"selectedFriends": selectedFriends},
    );
    return response.data['data'];
  }

  ///获取livekittoken
  Future<String> getLivekitToken(int groupId) async {
    Response response = await DioInstance.instance().get(
      path: "/api/group/getlivekittoken/$groupId",
    );
    return response.data['data'];
  }

  ///推送帖子
  Future<String> postTimeline(
    int? id,
    String context,
    List<XFile> imgFiles,
    String createTime,
  ) async {
    List<MultipartFile> files = [];

    for (XFile file in imgFiles) {
      //final mimeType = lookupMimeType(path) ?? 'application/octet-stream';
      files.add(
        await MultipartFile.fromFile(
          file.path,
          filename: file.name,
          // contentType: DioMediaType.parse(mimeType),
        ),
      );
    }
    FormData formData = FormData.fromMap({
      "userId": id,
      "context": context,
      "files": files,
    });
    Response response = await DioInstance.instance().post(
      path: "/api/timeline/posttimeline",
      data: formData,
    );

    return response.data['data'];
  }

  ///刷新获取帖子
  Future<List<TimelinePostData>> getTimelinePost(
    int limit,
    DateTime? cursorTime,
    int? cursorId,
  ) async {
    final params = <String, dynamic>{"limit": limit};
    if (cursorTime != null) {
      params["cursorTime"] = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(cursorTime);
      params["cursorId"] = cursorId;
    }
    Response response = await DioInstance.instance().get(
      path: "/api/timeline/gettimelinepost",
      param: params,
    );
    final List list = response.data['data'];

    return list.map((json) => TimelinePostData.fromJson(json)).toList();
  }

  ///获取指定帖子数据
  Future<TimelinePostData> getTimelinePostById(int timelineId) async {
    Response response = await DioInstance.instance().get(
      path: "/api/timeline/gettimelinepostbytimelindid",
      param: {"timelineId": timelineId},
    );
    return TimelinePostData.fromJson(response.data['data']);
  }

  ///给帖子点赞
  Future<void> timelineHitLike(int timelineId) async {
    Response response = await DioInstance.instance().post(
      path: "/api/timeline/hitlike",
      data: timelineId,
    );
  }

  ///给帖子评论
  Future<void> postComment(int timelineId, String comment) async {
    Response response = await DioInstance.instance().post(
      path: "/api/timeline/postcomment",
      data: {"timelineId": timelineId, "comment": comment},
    );
  }

  ///获取指定用户id的头像url
  Future<String> getUserAvatarUrl(int userId) async {
    Response response = await DioInstance.instance().get(
      path: "/api/user/getuseravatar",
      param: {"userId": userId},
    );
    return response.data['data'].toString();
  }

  ///根据keyword查找用户
  Future<List<SearchForUserData>> searchForUsers(String keyword) async {
    Response response = await DioInstance.instance().get(
      path: "/api/friend/searchforusers",
      param: {"keyword": keyword},
    );
    final List list = response.data['data'];
    return list.map((e) => SearchForUserData.fromJson(e)).toList();
  }

  //申请好友
  Future<void> sendFriendRequest(int userId) async {
    await DioInstance.instance().post(
      path: "/api/friend/sendfriendrequest",
      queryParameters: {"userId": userId},
    );
  }

  //回复好友申请
  Future<void> friendRequestResponse(int friendId, int res) async {
    await DioInstance.instance().post(
      path: "/api/friend/friendrequestresponse",
      queryParameters: {"friendId": friendId, "res": res},
    );
  }

  //获取正在申请成为我好友的用户
  Future<List<SearchForUserData>> getRequestFriends() async {
    Response response = await DioInstance.instance().get(
      path: "/api/friend/getrequestfriends",
    );
    final List list = response.data['data'];
    return list.map((e) => SearchForUserData.fromJson(e)).toList();
  }
}
