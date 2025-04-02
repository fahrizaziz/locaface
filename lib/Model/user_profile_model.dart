import 'dart:convert';

import 'package:locaface/Model/user_model.dart';

class UserProfileModel {
  String? msg, imageUrl;
  UserModel? user;

  UserProfileModel({this.imageUrl, this.msg, this.user});

  factory UserProfileModel.fromJson(String str) =>
      UserProfileModel.fromMap(jsonDecode(str));

  String toJson() => jsonEncode(toMap()); // Corrected this line

  factory UserProfileModel.fromMap(Map<String, dynamic> json) {
    return UserProfileModel(
      msg: json['message'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = msg;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['image_url'] = imageUrl;
    return data;
  }
}
