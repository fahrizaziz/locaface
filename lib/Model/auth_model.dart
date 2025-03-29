import 'package:locaface/Model/user_model.dart';

class AuthModel {
  String? token;
  UserModel? user;

  AuthModel({this.token, this.user});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'];
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
