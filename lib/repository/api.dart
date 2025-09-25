import 'package:demo10/repository/datas/auth_data.dart';
import 'package:demo10/repository/datas/common_website_data.dart';
import 'package:demo10/repository/datas/friendlist_data.dart';
import 'package:demo10/repository/datas/home_banner_data.dart';
import 'package:demo10/repository/datas/home_list_data.dart';
import 'package:demo10/repository/datas/login_data.dart';
import 'package:demo10/repository/datas/search_hot_keys_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../http/dio_instance.dart';

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
  Future<LoginData> login({String? emailaddress, String? password}) async {
    Response response = await DioInstance.instance().post(
      path: "/user/login",
      data: {"emailaddress": emailaddress, "password": password},
    );
    print("用户：${response.data["id"]}登录");
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
  Future<FriendlistData> getFriendList() async {
    Response response = await DioInstance.instance().get(
      path: "/user/getFriendList"
    );
    print("获得好友列表：${response.data}");
    return FriendlistData.fromJson(response.data);
  }
  //点击好友列表名字后添加到好友聊天列表
  addFriendToFriendChatList(String name){

  }
}
