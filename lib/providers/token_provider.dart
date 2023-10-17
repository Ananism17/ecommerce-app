import 'package:flutter/material.dart';

class TokenProvider with ChangeNotifier {
  // static const TOKEN = "TOKEN";

  String _token = "";
  String get getAccessToken => _token;



  setToken(String value) async {
    _token = value;
    notifyListeners();
  }

  
}
