import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String name = "";
  String email = "";
  String phone = "";
  String address = "";

  void updateUser(String newName, String newEmail, String newPhone, String newAddress) {
    name = newName;
    email = newEmail;
    phone = newPhone;
    address = newAddress;
    notifyListeners();
  }

  // Getter methods to retrieve user data
  String get userName => name;
  String get userEmail => email;
  String get userPhone => phone;
  String get userAddress => address;
}