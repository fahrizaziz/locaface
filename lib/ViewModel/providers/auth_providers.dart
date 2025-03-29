import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:locaface/Model/auth_model.dart';
import 'package:locaface/ViewModel/shared/api.dart';
import 'package:locaface/ViewModel/shared/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/gif_widget.dart';

class AuthProviders with ChangeNotifier {
  final urlLogin = Api.login;

  bool _isLoading = false;
  String _resMessage = '';
  AuthModel _auth = AuthModel();

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  AuthModel get auth => _auth;

  set auth(AuthModel auth) {
    _auth = auth;
    notifyListeners();
  }

  Future<bool> checkLogin() async {
    final savedUser = await UserPreferences().getUserModel();
    if (savedUser == null) {
      return false;
    }

    _auth = savedUser;
    return true;
  }

  Future<AuthModel?> login({
    String? email,
    password,
    BuildContext? context,
  }) async {
    print(email);
    print(password);
    _isLoading = true;
    notifyListeners();

    final body = jsonEncode({"email": email!, "password": password!});
    print(body);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      Response req = await post(
        Uri.parse(urlLogin),
        headers: headers,
        body: body,
      );
      print('masuk kesini : ${req.statusCode}');
      if (req.statusCode == 200) {
        final res = jsonDecode(req.body);
        AuthModel user = AuthModel.fromJson(res);
        _isLoading = false;
        notifyListeners();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', user.token!);
        prefs.setString(
          'user'
          'email',
          email,
        );
        prefs.setString(
          'user'
          'password',
          password,
        );

        await UserPreferences().setToken(user.token!);
        await UserPreferences().setUserModel(user);
        await UserPreferences().setAuthEmail(email);
        await UserPreferences().setAuthPassword(password);
        if (context != null) {
          showDialog(
            context: context,
            builder:
                (_) => AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    child: const Center(child: GifWidget(iconData: 'loading')),
                  ),
                ),
          );
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            context.go('/mainscreen'); // Navigasi ke halaman utama
          }
        }
      }
    } catch (e) {
      print('yah kesini');
      print(e.toString());
    }
  }
}
