import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:demo10/manager/FriendListManager.dart';
import 'package:demo10/pages/chat/groupChat_page.dart';
import 'package:demo10/pages/social/store/timeline_vm.dart';
import 'package:demo10/repository/datas/auth_data.dart';
import 'package:demo10/repository/datas/common_website_data.dart';
import 'package:demo10/repository/datas/friendList_data.dart';
import 'package:demo10/repository/datas/friendlist_data.dart'
    hide FriendListData;
import 'package:demo10/repository/datas/groupChat_data.dart';
import 'package:demo10/repository/datas/groupMessageData_data.dart';
import 'package:demo10/repository/datas/groupMessage_data.dart';
import 'package:demo10/repository/datas/home_banner_data.dart';
import 'package:demo10/repository/datas/home_list_data.dart';
import 'package:demo10/repository/datas/login_data.dart';
import 'package:demo10/repository/datas/search_hot_keys_data.dart';
import 'package:demo10/repository/datas/timeline/timlinePost_data.dart';
import 'package:demo10/repository/datas/user/updateUserInfo_data.dart';
import 'package:demo10/repository/datas/user/userInfo_data.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import '../http/dio_instance.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class Api {
  static Api instance = Api._();

  Api._();

  ///获取首页banner数据
  Future<List<HomeBannerData?>?> getBanner() async {
    Response response = await DioInstance.instance().get(path: "banner/json");
    HomeBannerListData bannerData = HomeBannerListData.fromJson(
      response.data["data"],
    );
    return bannerData.bannerList;
  }

  ///获取首页文章列表
  Future<List<HomeListItemData>?> getHomeList(String pageCount) async {
    Response response = await DioInstance.instance().get(
      path: "article/list/$pageCount/json",
    );
    HomeListData homeData = HomeListData.fromJson(response.data["data"]);
    return homeData.datas;
  }

  ///获取首页置顶数据
  Future<List<HomeListItemData>?> getHomeTopList() async {
    Response response = await DioInstance.instance().get(
      path: "article/top/json",
    );
    HomeTopListData homeData = HomeTopListData.fromJson(response.data["data"]);
    return homeData.topList;
  }

  ///获取常用网站
  Future<List<CommonWebsiteData>?> getWebsiteList() async {
    Response response = await DioInstance.instance().get(path: "friend/json");
    CommonWebsiteListData websiteListData = CommonWebsiteListData.fromJson(
      response.data["data"],
    );
    return websiteListData.websiteList;
  }

  ///获取搜索热点
  Future<List<SearchHotKeysData>?> getSearchHotKeys() async {
    Response response = await DioInstance.instance().get(path: "hotkey/json");
    SearchHotKeysListData hotKeysListData = SearchHotKeysListData.fromJson(
      response.data["data"],
    );
    return hotKeysListData.keyList;
  }

  ///注册
  Future<dynamic> register({
    String? name,
    String? password,
    String? rePassword,
  }) async {
    Response response = await DioInstance.instance().post(
      path: "user/register",
      queryParameters: {
        "username": name,
        "password": password,
        "repassword": rePassword,
      },
    );
    return true;
  }

  ///登录
  Future<LoginData> login({
    String? emailaddress,
    String? password,
    String? pushToken,
  }) async {
    Response response = await DioInstance.instance().post(
      path: "/user/login",
      data: {
        "emailaddress": emailaddress,
        "password": password,
        "pushToken": pushToken,
      },
    );
    print("用户：${response.data['data']['id']}登录");
    return LoginData.fromJson(response.data);
  }

  ///收藏
  Future<bool?> collect(String? id) async {
    Response response = await DioInstance.instance().post(
      path: "lg/collect/$id/json",
    );
    //return boolCallback(response.data);
    return true;
  }

  ///取消收藏
  Future<bool?> unCollect(String? id) async {
    Response response = await DioInstance.instance().post(
      path: "lg/uncollect_originId/$id/json",
    );
    //return boolCallback(response.data);
    return true;
  }

  ///登出
  Future<bool?> logout() async {
    Response response = await DioInstance.instance().get(
      path: "user/logout/json",
    );
    //return boolCallback(response.data);
    return true;
  }

  bool? boolCallback(dynamic data) {
    if (data["data"] != null && data["data"] is bool) {
      return true;
    }
    return false;
  }

  //获取好友列表
  Future<FriendListData> getFriendList() async {
    Response response = await DioInstance.instance().get(
      path: "/user/getfriendList",
    );
    print("获得好友列表：${response.data}");
    return FriendListData.fromJson(response.data);
  }

  //点击好友列表名字后添加到好友聊天列表
  addFriendToFriendChatList(String name) {}

  //建群
  Future<GroupChatData> createGroupChat(List<int> selectedFriends) async {
    Response response = await DioInstance.instance().post(
      path: "/user/creategroupchat",
      data: {"selectedFriends": selectedFriends},
    );
    //
    print("创建群聊: ${response.data}");
    GroupChatData groupChatData = GroupChatData.fromJson(response.data);

    return groupChatData;
  }

  //获取群信息
  Future<GroupChatData> getGroupChat(int groupId) async {
    Response response = await DioInstance.instance().get(
      path: "/user/getgroupchat",
      param: {'groupId': groupId},
    );
    //
    print("获取群聊信息: ${response.data}");
    return GroupChatData.fromJson(response.data);
  }

  //获取聊天列表
  Future<dynamic> getChatList() async {
    Response response = await DioInstance.instance().get(
      path: "/user/getchatlist",
    );
    print("获取聊天列表: ${response.data}");
    var data = response.data;
    return data;
  }

  //获得群聊天消息
  Future<GroupMessageData> getGroupMessages(int groupId) async {
    Response response = await DioInstance.instance().get(
      path: "/user/getgroupmessages",
      param: {'groupId': groupId},
    );
    print("获取群消息: ${response.data}");
    GroupMessageData groupMessageData = GroupMessageData.fromJson(
      response.data,
    );
    return groupMessageData;
  }

  //保存群消息到后端数据库
  Future<void> saveGroupMessage(
      GroupMessageDataData groupMessageDataData,) async {
    Response response = await DioInstance.instance().post(
      path: "/user/saveGroupMessage",
      queryParameters: {'groupMessageDTO': groupMessageDataData},
    );
    print("保存聊天消息到后端: ${response.data}");
  }

  //获取用户数据
  Future<UserInfoData> getUserInfo() async {
    Response response = await DioInstance.instance().get(
      path: "/user/getuserinfo",
    );
    return UserInfoData.fromJson(response.data['data']);
  }

  //更新用户数据
  Future<bool> updateUserInfo(UserInfoDTO userInfoDTO) async {
    Response response = await DioInstance.instance().post(
      path: "/user/updateuserinfo",
      queryParameters: {'updateUserInfoDTO': userInfoDTO},
    );
    return response.data['data'];
  }

  //上传头像到s3
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
      path: "/user/uploadavatar",
      data: formData,
    );
    return response.data['data'];
  }

  //添加群成员
  Future<bool> addGroupMembers(int groupId, List<int> selectedFriends) async {
    Response response = await DioInstance.instance().post(
      path: "/group/addgroupmembers/$groupId",
      data: {"selectedFriends": selectedFriends},
    );
    return response.data['data'];
  }

  //移除群成员
  Future<bool> removeGroupMembers(int groupId,
      List<int> selectedFriends,) async {
    Response response = await DioInstance.instance().post(
      path: "/group/removegroupmembers/$groupId",
      data: {"selectedFriends": selectedFriends},
    );
    return response.data['data'];
  }

  //获取livekittoken
  Future<String> getLivekitToken(int groupId) async {
    Response response = await DioInstance.instance().get(
      path: "/group/getlivekittoken/$groupId",
    );
    return response.data['data'];
  }

  //推送帖子
  Future<String> postTimeline(int? id,
      String context,
      List<XFile> imgFiles,
      String createTime,) async {
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
      path: "/timeline/posttimeline",
      data: formData,
    );

    return response.data['data'];
  }

  //刷新获取帖子
  Future<List<TimelinePost>> getTimelinePost() async {
    Response response = await DioInstance.instance().get(
      path: "/timeline/gettimelinepost",
    );
    final List list = response.data['data'];

    return list
        .map((json) => TimelinePost.fromJson(json))
        .toList();
  }
}
