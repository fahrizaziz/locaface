import 'package:locaface/Model/attendance_model.dart';

class CheckinoutModel {
  String? msg;
  AttendanceModel? attendance;

  CheckinoutModel({this.attendance, this.msg});

  factory CheckinoutModel.fromJson(Map<String, dynamic> json) {
    return CheckinoutModel(
      msg: json['message'],
      attendance:
          json['attendance'] == null
              ? null
              : AttendanceModel.fromJson(json['attendance']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = msg;
    data['attendacne'] = attendance!.toJson();
    return data;
  }
}
