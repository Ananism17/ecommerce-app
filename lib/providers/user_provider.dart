import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String _name = "";
  String _email = "";
  String _phone = "";
  String _address = "";

  String get userName => _name;
  String get userEmail => _email;
  String get userPhone => _phone;
  String get userAddress => _address;

  UserProvider() {
    // Load user data from SharedPreferences when the provider is instantiated
    loadUser();
  }

  void updateUser(String newName, String newEmail, String newPhone, String newAddress) {
    _name = newName;
    _email = newEmail;
    _phone = newPhone;
    _address = newAddress;

    // Save updated user data to SharedPreferences
    saveUser();

    notifyListeners();
  }

  // Load user data from SharedPreferences
  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("USER_NAME") ?? "";
    _email = prefs.getString("USER_EMAIL") ?? "";
    _phone = prefs.getString("USER_PHONE") ?? "";
    _address = prefs.getString("USER_ADDRESS") ?? "";

    notifyListeners();
  }

  // Save user data to SharedPreferences
  Future<void> saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("USER_NAME", _name);
    prefs.setString("USER_EMAIL", _email);
    prefs.setString("USER_PHONE", _phone);
    prefs.setString("USER_ADDRESS", _address);
  }
}