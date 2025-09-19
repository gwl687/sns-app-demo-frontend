/// code : 1
/// msg : null
/// data : {"name":null,"token":"eyJhbGciOiJIUzI1NiJ9.eyJpZCI6NywiaWF0IjoxNzU3OTAwOTczLCJleHAiOjE3NTg1MDU3NzN9.B73JAmzQyeej7CMeoh4vpS7CV_JUYehn2HlGhDvqKUM","userName":"testuser","id":7}

class LoginData {
  LoginData({
      num? code, 
      dynamic msg, 
      Data? data,}){
    _code = code;
    _msg = msg;
    _data = data;
}

  LoginData.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? _code;
  dynamic _msg;
  Data? _data;
LoginData copyWith({  num? code,
  dynamic msg,
  Data? data,
}) => LoginData(  code: code ?? _code,
  msg: msg ?? _msg,
  data: data ?? _data,
);
  num? get code => _code;
  dynamic get msg => _msg;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// name : null
/// token : "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6NywiaWF0IjoxNzU3OTAwOTczLCJleHAiOjE3NTg1MDU3NzN9.B73JAmzQyeej7CMeoh4vpS7CV_JUYehn2HlGhDvqKUM"
/// userName : "testuser"
/// id : 7

class Data {
  Data({
      dynamic name, 
      String? token, 
      String? userName, 
      num? id,}){
    _name = name;
    _token = token;
    _userName = userName;
    _id = id;
}

  Data.fromJson(dynamic json) {
    _name = json['name'];
    _token = json['token'];
    _userName = json['userName'];
    _id = json['id'];
  }
  dynamic _name;
  String? _token;
  String? _userName;
  num? _id;
Data copyWith({  dynamic name,
  String? token,
  String? userName,
  num? id,
}) => Data(  name: name ?? _name,
  token: token ?? _token,
  userName: userName ?? _userName,
  id: id ?? _id,
);
  dynamic get name => _name;
  String? get token => _token;
  String? get userName => _userName;
  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['token'] = _token;
    map['userName'] = _userName;
    map['id'] = _id;
    return map;
  }

}