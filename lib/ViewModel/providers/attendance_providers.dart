import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:locaface/Model/checkinout_model.dart';
import 'package:locaface/Model/company_response_model.dart';

import '../shared/api.dart';
import '../shared/user_preferences.dart';

class AttendanceProviders with ChangeNotifier {
  final urlCompany = Api.company;
  final urlIscheck = Api.isCheck;
  final urlCheckIn = Api.checkIn;
  final urlCheckOut = Api.checkOut;

  bool? _isCheckedIn;
  bool _isLoading = false;
  String _resMessage = '';
  bool get isCheckedIn => _isCheckedIn ?? false; // Default to false if null
  CompanyResponseModel _company = CompanyResponseModel();
  CheckinoutModel _checkinout = CheckinoutModel();

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  CompanyResponseModel get company => _company;
  CheckinoutModel get checkinout => _checkinout;

  set companys(CompanyResponseModel company) {
    _company = company;
    notifyListeners();
  }

  set checkinouts(CheckinoutModel checkinout) {
    _checkinout = checkinout;
    notifyListeners();
  }

  Future<CompanyResponseModel?> getCompany({BuildContext? context}) async {
    _isLoading = true;
    notifyListeners();
    final token = await UserPreferences().getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      Response req = await get(Uri.parse(urlCompany), headers: headers);
      if (req.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        final res = jsonDecode(req.body);
        CompanyResponseModel.fromJson(res);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool?> isCheckin() async {
    _isLoading = true;
    notifyListeners();
    final token = await UserPreferences().getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      Response req = await get(Uri.parse(urlIscheck), headers: headers);
      if (req.statusCode == 200) {
        final res = jsonDecode(req.body);
        _isCheckedIn = res['checkedin'] ?? false; // Parse the response
        _isLoading = false;
        notifyListeners();
        return _isCheckedIn;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<CheckinoutModel?> checkin({
    BuildContext? context,
    String? lat,
    long,
  }) async {
    _isLoading = true;
    notifyListeners();
    final token = await UserPreferences().getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({"latitude": lat!, "longitude": long!});
    try {
      Response req = await post(
        Uri.parse(urlCheckIn),
        headers: headers,
        body: body,
      );
      if (req.statusCode == 200) {
        final res = jsonDecode(req.body);
        CheckinoutModel.fromJson(res);
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<CheckinoutModel?> checkout({
    BuildContext? context,
    String? lat,
    long,
  }) async {
    _isLoading = true;
    notifyListeners();
    final token = await UserPreferences().getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({"latitude": lat!, "longitude": long!});
    print('Body : $body');
    try {
      Response req = await post(
        Uri.parse(urlCheckOut),
        headers: headers,
        body: body,
      );
      print('Check Out ; ${req.statusCode}');
      if (req.statusCode == 200) {
        final res = jsonDecode(req.body);
        CheckinoutModel.fromJson(res);
        _isLoading = false;
        notifyListeners();
        print('sini');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
