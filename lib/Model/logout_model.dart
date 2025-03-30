class LogoutModel {
  String? msg;

  LogoutModel({this.msg});

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(msg: json['message']);
  }
}
