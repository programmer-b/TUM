part of 'package:tum/Models/models.dart';

class NewData {
  Profile? profile;
  String? token;
  Settings? settings;

  NewData({this.profile, this.token, this.settings});

  NewData.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    token = json['token'];
    settings =
        json['settings'] != null ? Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['token'] = token;
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    return data;
  }
}

class Profile {
  String? fullName;
  String? regNo;
  String? phoneNo;
  String? userId;
  ProfileImage? profileImage;

  Profile(
      {this.fullName,
      this.regNo,
      this.phoneNo,
      this.userId,
      this.profileImage});

  Profile.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    regNo = json['regNo'];
    phoneNo = json['phoneNo'];
    userId = json['userId'];
    profileImage = json['profileImage'] != null
        ? ProfileImage.fromJson(json['profileImage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['regNo'] = regNo;
    data['phoneNo'] = phoneNo;
    data['userId'] = userId;
    if (profileImage != null) {
      data['profileImage'] = profileImage!.toJson();
    }
    return data;
  }
}

class ProfileImage {
  String? url;
  String? name;
  String? id;

  ProfileImage({this.url, this.name, this.id});

  ProfileImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

class Settings {
  String? theme;

  Settings({this.theme});

  Settings.fromJson(Map<String, dynamic> json) {
    theme = json['theme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['theme'] = theme;
    return data;
  }
}
