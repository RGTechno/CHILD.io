import 'dart:convert';

import 'package:child_io/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class AuthProvider extends ChangeNotifier {
  Future<bool?> getAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final auth = prefs.getBool('isAuthenticated');
    return auth;
  }

  Future<void> register({
    required BuildContext ctx,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      var url = Uri.https(apiHost, "/api/auth/register");
      var response = await http.post(url,
          body: json.encode({
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password,
          }),
          headers: {'Content-Type': 'application/json'});
      var jsonResponse = json.decode(response.body);
      if (jsonResponse["success"] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isAuthenticated", true);
        await prefs.setString("user", json.encode(jsonResponse["data"]));
      } else {
        showDialog(
          context: ctx,
          builder: (context) => AlertDialog(
            title: Text("OOPS"),
            content: Text(jsonResponse["message"]),
          ),
        );
      }
    } catch (err, stack) {
      print(err);
    }
    notifyListeners();
  }

  Future<void> login({
    required BuildContext ctx,
    required String email,
    required String password,
  }) async {
    try {
      var url = Uri.https(apiHost, "/api/auth/login");
      var response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
          }),
          headers: {'Content-Type': 'application/json'});
      var jsonResponse = json.decode(response.body);
      if (jsonResponse["success"] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isAuthenticated", true);
        await prefs.setString("user", json.encode(jsonResponse["data"]));
      } else {
        showDialog(
          context: ctx,
          builder: (context) => AlertDialog(
            title: Text("OOPS"),
            content: Text(jsonResponse["message"]),
          ),
        );
      }
    } catch (err, stack) {
      print(err);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("isAuthenticated");
      await prefs.remove("user");
    } catch (err, stack) {
      print(err);
    }
    notifyListeners();
  }
}
