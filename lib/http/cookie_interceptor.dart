import 'dart:io';

import 'package:demo10/constants.dart';
import 'package:demo10/http/rsp_interceptor.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:dio/dio.dart';

class CookieInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //取出本地cookie
    SpUtils.getStringList(Constants.SP_COOKIE_List).then((cookieList) {
      //塞到请求头里
      options.headers[HttpHeaders.cookieHeader] = cookieList;
      //继续往下执行
      handler.next(options);
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.path.contains("user/login")) {
      //去除cookie信息
      dynamic list = response.headers[HttpHeaders.setCookieHeader];
      List<String> cookieList = [];
      if (list is List) {
        for (String? cookie in list) {
          cookieList.add(cookie ?? "");
          print("CookieInteceptor cookie=${cookie.toString()}");
        }
      }
      SpUtils.saveStringList(Constants.SP_COOKIE_List, cookieList);
    }
    super.onResponse(response, handler);
  }
}
