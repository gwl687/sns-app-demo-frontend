/// code : 1
/// msg : null
/// data : [{"name":null,"userName":"user1","id":10},{"name":null,"userName":"user2","id":11},{"name":null,"userName":"user3","id":12},{"name":null,"userName":"user4","id":13},{"name":null,"userName":"user5","id":14},{"name":null,"userName":"user6","id":15},{"name":null,"userName":"user7","id":16},{"name":null,"userName":"user8","id":17},{"name":null,"userName":"user9","id":18}]

class FriendlistData {
  FriendlistData({
      num? code, 
      dynamic msg, 
      List<Data>? data,}){
    _code = code;
    _msg = msg;
    _data = data;
}

  FriendlistData.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  num? _code;
  dynamic _msg;
  List<Data>? _data;
FriendlistData copyWith({  num? code,
  dynamic msg,
  List<Data>? data,
}) => FriendlistData(  code: code ?? _code,
  msg: msg ?? _msg,
  data: data ?? _data,
);
  num? get code => _code;
  dynamic get msg => _msg;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// name : null
/// userName : "user1"
/// id : 10

class Data {
  Data({
      dynamic name, 
      String? userName, 
      num? id,}){
    _name = name;
    _userName = userName;
    _id = id;
}

  Data.fromJson(dynamic json) {
    _name = json['name'];
    _userName = json['userName'];
    _id = json['id'];
  }
  dynamic _name;
  String? _userName;
  num? _id;
Data copyWith({  dynamic name,
  String? userName,
  num? id,
}) => Data(  name: name ?? _name,
  userName: userName ?? _userName,
  id: id ?? _id,
);
  dynamic get name => _name;
  String? get userName => _userName;
  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['userName'] = _userName;
    map['id'] = _id;
    return map;
  }

}