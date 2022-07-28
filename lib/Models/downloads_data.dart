part of 'package:tum/Models/models.dart';

class DownloadsData {
  String? title;
  String? url;
  int? index;

  DownloadsData({this.title, this.url, this.index});

  DownloadsData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['url'] = url;
    data['index'] = index;
    return data;
  }
}
