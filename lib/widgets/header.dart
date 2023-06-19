import 'dart:convert';

import 'package:child_io/color.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class Header extends StatefulWidget {
  final double height;
  final int coins;
  final bool showDrawer;

  const Header(this.coins, this.height, this.showDrawer);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _isloading = false;
  int coins = 0;

  Future<void> getCoins() async {
    try {
      setState(() {
        _isloading = true;
      });
      final prefs = await SharedPreferences.getInstance();
      var userData = await prefs.getString("user");
      var jsonUser = json.decode(userData!);
      var url = Uri.https(apiHost, "/api/child/coins", {
        "userID": jsonUser["userID"].toString(),
      });
      var response = await http.get(url);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      setState(() {
        _isloading = false;
        coins = jsonResponse["data"]["coins"] != null
            ? jsonResponse["data"]["coins"]
            : 0;
      });
      print("Coins $coins");
    } catch (err) {
      print(err);
    }
  }

  Future<void> init() async {
    await getCoins();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.showDrawer
              ? IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                )
              : Container(),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: accentColor),
                borderRadius: BorderRadius.circular(50)),
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/coin.png", fit: BoxFit.cover),
                _isloading
                    ? LoadingAnimationWidget.halfTriangleDot(
                        color: accentColor,
                        size: 20,
                      )
                    : Text(
                        coins.toString(),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
