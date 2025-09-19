/// admin : false
/// chapterTops : []
/// coinCount : 10
/// collectIds : []
/// email : ""
/// icon : ""
/// id : 168565
/// nickname : "gwl"
/// password : ""
/// publicName : "gwl"
/// token : ""
/// type : 0
/// username : "gwl"

class AuthData {
  AuthData({
      bool? admin, 
      List<dynamic>? chapterTops, 
      num? coinCount, 
      List<dynamic>? collectIds, 
      String? email, 
      String? icon, 
      num? id, 
      String? nickname, 
      String? password, 
      String? publicName, 
      String? token, 
      num? type, 
      String? username,}){
    _admin = admin;
    _chapterTops = chapterTops;
    _coinCount = coinCount;
    _collectIds = collectIds;
    _email = email;
    _icon = icon;
    _id = id;
    _nickname = nickname;
    _password = password;
    _publicName = publicName;
    _token = token;
    _type = type;
    _username = username;
}

  AuthData.fromJson(dynamic json) {
    _admin = json['admin'];
    if (json['chapterTops'] != null) {
      _chapterTops = [];
      json['chapterTops'].forEach((v) {
        _chapterTops?.add(v);
      });
    }
    _coinCount = json['coinCount'];
    if (json['collectIds'] != null) {
      _collectIds = [];
      json['collectIds'].forEach((v) {
        _collectIds?.add(v);
      });
    }
    _email = json['email'];
    _icon = json['icon'];
    _id = json['id'];
    _nickname = json['nickname'];
    _password = json['password'];
    _publicName = json['publicName'];
    _token = json['token'];
    _type = json['type'];
    _username = json['username'];
  }
  bool? _admin;
  List<dynamic>? _chapterTops;
  num? _coinCount;
  List<dynamic>? _collectIds;
  String? _email;
  String? _icon;
  num? _id;
  String? _nickname;
  String? _password;
  String? _publicName;
  String? _token;
  num? _type;
  String? _username;
AuthData copyWith({  bool? admin,
  List<dynamic>? chapterTops,
  num? coinCount,
  List<dynamic>? collectIds,
  String? email,
  String? icon,
  num? id,
  String? nickname,
  String? password,
  String? publicName,
  String? token,
  num? type,
  String? username,
}) => AuthData(  admin: admin ?? _admin,
  chapterTops: chapterTops ?? _chapterTops,
  coinCount: coinCount ?? _coinCount,
  collectIds: collectIds ?? _collectIds,
  email: email ?? _email,
  icon: icon ?? _icon,
  id: id ?? _id,
  nickname: nickname ?? _nickname,
  password: password ?? _password,
  publicName: publicName ?? _publicName,
  token: token ?? _token,
  type: type ?? _type,
  username: username ?? _username,
);
  bool? get admin => _admin;
  List<dynamic>? get chapterTops => _chapterTops;
  num? get coinCount => _coinCount;
  List<dynamic>? get collectIds => _collectIds;
  String? get email => _email;
  String? get icon => _icon;
  num? get id => _id;
  String? get nickname => _nickname;
  String? get password => _password;
  String? get publicName => _publicName;
  String? get token => _token;
  num? get type => _type;
  String? get username => _username;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['admin'] = _admin;
    if (_chapterTops != null) {
      map['chapterTops'] = _chapterTops?.map((v) => v.toJson()).toList();
    }
    map['coinCount'] = _coinCount;
    if (_collectIds != null) {
      map['collectIds'] = _collectIds?.map((v) => v.toJson()).toList();
    }
    map['email'] = _email;
    map['icon'] = _icon;
    map['id'] = _id;
    map['nickname'] = _nickname;
    map['password'] = _password;
    map['publicName'] = _publicName;
    map['token'] = _token;
    map['type'] = _type;
    map['username'] = _username;
    return map;
  }

}