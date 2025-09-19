import 'package:demo10/http/Base_model.dart';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onReponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      try {
        //
        //
        var rsp = BaseModel.fromJson(response.data);
        if (rsp.errorCode == 0) {
          if (rsp.data == null) {
            handler.next(
              Response(requestOptions: response.requestOptions, data: true),
            );
          } else {
            handler.next(
              Response(requestOptions: response.requestOptions, data: rsp.data),
            );
          }
        }else if (rsp.errorCode == -1001) {
          //需要登录
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              message: "未登录",
            ),
          );
          showToast("请先登录");
        }else if (rsp.errorCode == -1) {
          showToast(rsp.errorMsg ??"");
          if(rsp.data == null ){
            handler.next(Response(requestOptions: response.requestOptions,data:false));
          }else{
            handler.next(Response(requestOptions: response.requestOptions,data: rsp.data));
          }
        }
      } catch (e) {
        handler.reject(
          DioException(requestOptions: response.requestOptions, message: "$e"),
        );
      }
    } else {
      handler.reject(DioException(requestOptions: response.requestOptions));
    }
  }
}
