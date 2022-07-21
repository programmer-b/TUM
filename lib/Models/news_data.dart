part of 'package:tum/Models/models.dart';

class NewsData {
  String? news;
  String? image;
  String? url;
  String? date;
  int? index;

  NewsData({this.news, this.image, this.url, this.date, this.index});

  NewsData.fromJson(Map<String, dynamic> json) {
    news = json['news'];
    image = json['image'];
    url = json['url'];
    date = json['date'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['news'] = news;
    data['image'] = image;
    data['url'] = url;
    data['date'] = date;
    data['index'] = index;
    return data;
  }
}
