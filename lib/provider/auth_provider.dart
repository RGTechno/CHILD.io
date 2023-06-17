import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  Future<bool?> getAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final auth = prefs.getBool('isAuthenticated');
    return auth;
  }

  Future<void> login(BuildContext ctx) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isAuthenticated", true);
    } catch (err, stack) {
      print(err);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("isAuthenticated");
    } catch (err, stack) {
      print(err);
    }
    notifyListeners();
  }
}
