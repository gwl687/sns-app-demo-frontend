import 'package:demo10/constants.dart';
import 'package:demo10/http/cookie_interceptor.dart';
import 'package:demo10/http/print_log_interceptor.dart';
import 'package:demo10/http/rsp_interceptor.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:demo10/constants.dart';

import 'http_method.dart';

class DioInstance {
  static DioInstance? _instance;

  DioInstance._();

  static DioInstance instance() {
    return _instance ??= DioInstance._();
  }

  final Dio _dio = Dio();
  final _defaultTime = const Duration(seconds: 30);

  //token
  //.SP_Token

  void initDio({
    required String baseUrl,
    String? httpMethod = HttpMethod.GET,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
    Map<String, dynamic>? headers,
  }) {
    _dio.options = BaseOptions(
      method: httpMethod,
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? _defaultTime,
      receiveTimeout: receiveTimeout ?? _defaultTime,
      sendTimeout: sendTimeout ?? _defaultTime,
      responseType: responseType,
      contentType: contentType,
      headers: headers,
    );
    //添加打印请求返回信息拦截器
    // _dio.interceptors.add(PrintLogInterceptor());
    //添加cookie拦截器
    //_dio.interceptors.add(CookieInterceptor());
    //添加统一返回值处理拦截器
    //_dio.interceptors.add(ResponseInterceptor());
  }

  ///get请求方法
  Future<Response> get({
    required String path,
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get(
      path,
      queryParameters: param,
      options: Options(
        method: HttpMethod.GET,
        receiveTimeout: _defaultTime,
        sendTimeout: _defaultTime,
        headers: {
          'Authorization':
              'Bearer ${await SpUtils.getString(Constants.SP_Token)}',
        },
      ),
      cancelToken: cancelToken,
    );
  }

  //POST请求方法
  Future<Response> post({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    String? myToken = await SpUtils.getString(Constants.SP_Token);
    final headers = {'Content-Type': Headers.jsonContentType};
    if (myToken != null) {
      headers['Authorization'] = 'Bearer $myToken';
    }
    return await _dio.post(
      path,
      queryParameters: queryParameters,
      data: data,
      cancelToken: cancelToken,
      options:
          options ??
          Options(
            method: HttpMethod.POST,
            headers: headers,
            receiveTimeout: _defaultTime,
            sendTimeout: _defaultTime,
            contentType: Headers.jsonContentType,
          ),
    );
  }
}
