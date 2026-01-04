import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/http/cookie_interceptor.dart';
import 'package:demo10/http/print_log_interceptor.dart';
import 'package:demo10/http/rsp_interceptor.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'http_method.dart';

class DioInstance {
  static DioInstance? _instance;

  DioInstance._();

  static DioInstance instance() {
    return _instance ??= DioInstance._();
  }

  final Dio _dio = Dio();
  final _defaultTime = const Duration(seconds: 30);

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

    _addInterceptors();
  }

  /// 拦截器
  void _addInterceptors() {
    _dio.interceptors.clear();

    /// cookie
    _dio.interceptors.add(CookieInterceptor());

    /// 统一响应
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SpUtils.getString(BaseConstants.SP_Token);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },

        onResponse: (response, handler) {
          final data = response.data;

          if (data is Map && data.containsKey('code')) {
            final code = data['code'];
            final msg = data['msg'];

            if (code != 1) {
              /// 业务错误
              if (msg != null) {
                showToast(msg.toString());
              }
              return handler.next(response);
              /// 阻断后续
              // return handler.reject(
              //   DioException(
              //     requestOptions: response.requestOptions,
              //     response: response,
              //     error: msg,
              //     type: DioExceptionType.badResponse,
              //   ),
              // );
            }
          }

          handler.next(response);
        },

        onError: (DioException e, handler) {
          /// 网络
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            showToast('网络连接超时');
          } else if (e.type == DioExceptionType.connectionError) {
            showToast('网络连接失败');
          } else if (e.message != null) {
            showToast(e.message!);
          }

          handler.next(e);
        },
      ),
    );
  }

  /// token失效
  void _handleUnauthorized() {
    SpUtils.remove(BaseConstants.SP_Token);
  }

  /// 请求方法
  Future<Response> get({
    required String path,
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get(
      path,
      queryParameters: param,
      options: options ??
          Options(
            method: HttpMethod.GET,
            receiveTimeout: _defaultTime,
            sendTimeout: _defaultTime,
          ),
      cancelToken: cancelToken,
    );
  }

  Future<Response> put({
    required String path,
    required Object? data,
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.put(
      path,
      queryParameters: param,
      data: data,
      options: options ??
          Options(
            method: HttpMethod.PUT,
            receiveTimeout: _defaultTime,
            sendTimeout: _defaultTime,
          ),
      cancelToken: cancelToken,
    );
  }

  Future<Response> post({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post(
      path,
      queryParameters: queryParameters,
      data: data,
      cancelToken: cancelToken,
      options: options ??
          Options(
            method: HttpMethod.POST,
            receiveTimeout: _defaultTime,
            sendTimeout: _defaultTime,
            contentType: Headers.jsonContentType,
          ),
    );
  }
}
