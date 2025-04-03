import 'dart:convert';

class AttendanceModel {
  int? id, userId;
  DateTime? date;
  String? timeIn, latlongIn;

  AttendanceModel({
    this.date,
    this.id,
    this.latlongIn,
    this.timeIn,
    this.userId,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      userId: json['user_id'],
      date: json['date'] == null ? null : DateTime.parse(json['date']),
      timeIn: json['time_in'],
      latlongIn: json['latlon_in'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['date'] =
        "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}";
    data['time_in'] = timeIn;
    data['latlon_in'] = latlongIn;
    data['id'] = id;
    return data;
  }
}
