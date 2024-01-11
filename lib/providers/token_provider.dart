import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider with ChangeNotifier {
  static const TOKEN_KEY = "ACCESS_TOKEN";

  String _token = "";
  String get getAccessToken => _token;

  TokenProvider() {
    getToken();
  }

  setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(TOKEN_KEY, value);
    _token = value;
    notifyListeners();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(TOKEN_KEY) ?? "";
    notifyListeners();
    return _token;
  }
}

