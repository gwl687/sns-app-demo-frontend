import 'package:demo10/http/dio_instance.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../repository/api.dart';
import '../../repository/datas/home_banner_data.dart';
import '../../repository/datas/home_list_data.dart';

class HomeViewModel with ChangeNotifier {
  int pageCount = 0;
  List<HomeBannerData?>? bannerList;
  List<HomeListItemData>? listData = [];

  ///获取首页banner数据
  Future getBanner() async {
    List<HomeBannerData?>? list = await Api.instance.getBanner();
    bannerList = list ?? [];
    notifyListeners();
  }

  Future initListData(bool loadMore, {ValueChanged<bool>? callback}) async {
    if (loadMore) {
      pageCount++;
    } else {
      pageCount = 1;
    }
    //先获取置顶数据
    getTopList(loadMore).then((topList) {
      if (!loadMore) {
        listData?.addAll(topList ?? []);
      }
      //再获取首页列表
      getHomeList(loadMore).then((allList) {
        listData?.addAll(allList ?? []);
        //刷新
        notifyListeners();
        //回调出去
        callback?.call(loadMore);
      });
    });
  }

  ///获取首页文章列表
  Future getHomeList(bool loadMore) async {
    List<HomeListItemData>? list = await Api.instance.getHomeList("$pageCount");
    if (list != null && list.isNotEmpty) {
      return list;
    } else {
      if (loadMore && pageCount > 0) {
        pageCount--;
      }
      return [];
    }
  }

  Future<List<HomeListItemData>?> getTopList(bool loadMore) async {
    if (loadMore) {
      return [];
    }
    List<HomeListItemData>? list = await Api.instance.getHomeTopList();
    return list;
  }

  Future collectOrNo(bool isCollect, String? id, int index) async {
    bool? success;
    if (isCollect) {
      success = await Api.instance.collect(id);
    } else {
      success = await Api.instance.unCollect(id);
    }
    if (success == true) {
      listData?[index].collect = isCollect;
      notifyListeners();
    }
  }
}
