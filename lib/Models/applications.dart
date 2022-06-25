
part of 'package:tum/Models/models.dart';


class Applications {
  String? icon;
  String? name;
  String? url;

  Applications({this.icon, this.name, this.url});

  Applications.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon;
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
