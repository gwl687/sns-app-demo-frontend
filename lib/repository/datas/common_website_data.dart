/// category : "源码"
/// icon : ""
/// id : 22
/// link : "https://www.androidos.net.cn/sourcecode"
/// name : "androidos"
/// order : 11
/// visible : 1
/// 搜索热点返回数据
class CommonWebsiteListData {
  List<CommonWebsiteData>? websiteList;

  CommonWebsiteListData.fromJson(dynamic json) {
    websiteList = [];
    if (json is List) {
      for (var element in json) {
        websiteList?.add(CommonWebsiteData.fromJson(element));
      }
    }
  }
}

class CommonWebsiteData {
  CommonWebsiteData({
    String? category,
    String? icon,
    num? id,
    String? link,
    String? name,
    num? order,
    num? visible,
  }) {
    _category = category;
    _icon = icon;
    _id = id;
    _link = link;
    _name = name;
    _order = order;
    _visible = visible;
  }

  CommonWebsiteData.fromJson(dynamic json) {
    _category = json['category'];
    _icon = json['icon'];
    _id = json['id'];
    _link = json['link'];
    _name = json['name'];
    _order = json['order'];
    _visible = json['visible'];
  }

  String? _category;
  String? _icon;
  num? _id;
  String? _link;
  String? _name;
  num? _order;
  num? _visible;

  CommonWebsiteData copyWith({
    String? category,
    String? icon,
    num? id,
    String? link,
    String? name,
    num? order,
    num? visible,
  }) => CommonWebsiteData(
    category: category ?? _category,
    icon: icon ?? _icon,
    id: id ?? _id,
    link: link ?? _link,
    name: name ?? _name,
    order: order ?? _order,
    visible: visible ?? _visible,
  );

  String? get category => _category;

  String? get icon => _icon;

  num? get id => _id;

  String? get link => _link;

  String? get name => _name;

  num? get order => _order;

  num? get visible => _visible;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category'] = _category;
    map['icon'] = _icon;
    map['id'] = _id;
    map['link'] = _link;
    map['name'] = _name;
    map['order'] = _order;
    map['visible'] = _visible;
    return map;
  }
}
