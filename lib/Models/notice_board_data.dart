part of 'package:tum/Models/models.dart';

class NoticeBoardData {
  String? notice;
  String? url;
  String? date;
  int? index;

  NoticeBoardData({this.notice, this.url, this.date, this.index});

  NoticeBoardData.fromJson(Map<String, dynamic> json) {
    notice = json['notice'];
    url = json['url'];
    date = json['date'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notice'] = notice;
    data['url'] = url;
    data['date'] = date;
    data['index'] = index;
    return data;
  }
}