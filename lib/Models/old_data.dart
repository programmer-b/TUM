part of 'package:tum/Models/models.dart';

class OldData {
  String? regNo;
  String? password;
  String? fullName;
  String? profileImage;
  String? elearningPassword;
  String? eregisterPassword;
  String? email;
  String? phoneNo;

  OldData(
      {this.regNo,
      this.password,
      this.fullName,
      this.profileImage,
      this.elearningPassword,
      this.eregisterPassword,
      this.email,
      this.phoneNo});

  OldData.fromJson(Map<String, dynamic> json) {
    regNo = json['regNo'];
    password = json['password'];
    fullName = json['fullName'];
    profileImage = json['profileImage'];
    elearningPassword = json['ElearningPassword'];
    eregisterPassword = json['EregisterPassword'];
    email = json['email'];
    phoneNo = json['phoneNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['regNo'] = regNo;
    data['password'] = password;
    data['fullName'] = fullName;
    data['profileImage'] = profileImage;
    data['ElearningPassword'] = elearningPassword;
    data['EregisterPassword'] = eregisterPassword;
    data['email'] = email;
    data['phoneNo'] = phoneNo;
    return data;
  }
}
