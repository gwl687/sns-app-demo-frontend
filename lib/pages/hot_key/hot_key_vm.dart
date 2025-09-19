import 'package:demo10/repository/datas/common_website_data.dart';
import 'package:demo10/repository/datas/search_hot_keys_data.dart';
import 'package:flutter/cupertino.dart';

import '../../repository/api.dart';

class HotKeyViewModel with ChangeNotifier{
    List<CommonWebsiteData>? websitelist;
    List<SearchHotKeysData>? keyList;
    ///获取数据
    Future initData()async{
      getWebsiteList().then((value){
        getSearchHotKeys().then((value){
          notifyListeners();
        });
      });
    }
    ///获取常用网站
    Future getWebsiteList() async {
      websitelist = await Api.instance.getWebsiteList();
    }
    ///获取搜索热点
    Future<List<SearchHotKeysData>?> getSearchHotKeys() async {
      keyList = await Api.instance.getSearchHotKeys();
    }
}