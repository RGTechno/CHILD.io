import 'dart:convert';

import 'package:child_io/color.dart';
import 'package:child_io/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class RanksScreen extends StatefulWidget {
  const RanksScreen({Key? key}) : super(key: key);

  @override
  State<RanksScreen> createState() => _RanksScreenState();
}

class _RanksScreenState extends State<RanksScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool _isLoading = false;
  var user;

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    var userData = await prefs.getString("user");
    var jsonUser = json.decode(userData!);
    setState(() {
      user = jsonUser;
    });
  }

  List ranks = [];

  Future<void> getLeaderBoard() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var url = Uri.https(apiHost, "/api/child/friends/leaderboard", {
        "userID": user["userID"].toString(),
      });
      var response = await http.get(url);
      print(response.body);
      var jsonResponse = json.decode(response.body);

      setState(() {
        ranks = jsonResponse["data"];
        _isLoading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  Future<void> init() async {
    await getUserData();
    await getLeaderBoard();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: secondaryColor,
                pinned: true,
                snap: false,
                floating: false,
                automaticallyImplyLeading: false,
                expandedHeight: mediaQuery.height * 0.35,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(4.0),
                  child: Container(
                    color: primaryColor,
                    height: mediaQuery.height * 0.06,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rank",
                            style: TextStyle(
                              color: Colors.grey[200],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Name",
                            style: TextStyle(
                                color: Colors.grey[200],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Score",
                            style: TextStyle(
                                color: Colors.grey[200],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          primaryColor,
                          primaryColor,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 8,
                          ),
                          child: Header(
                            300,
                            mediaQuery.height * 0.05,
                            false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Text(
                            "LEADERBOARD",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.emoji_events_rounded,
                          color: secondaryColor,
                          size: 70,
                        ),
                      ],
                    ),
                  ),
                ),
                elevation: 9.0,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) =>
                      buildList(context, index),
                  childCount: ranks.length,
                ),
              ),
            ],
          );
  }

  Widget buildList(BuildContext txt, int index) {
    final pos = index + 1;
    final name = ranks[index]["firstName"] + " " + ranks[index]["lastName"];
    final points = ranks[index]["points"];
    final userID = ranks[index]["userID"];

    Widget listItem;

    listItem = Card(
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      shadowColor: Colors.grey[200],
      color: userID == user["userID"] ? secondaryColor : Colors.white,
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              pos.toString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              name,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              points,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );

    return Stack(
      children: [
        Container(
          color: Colors.grey[200],
          child: listItem,
        ),
      ],
    );
  }
}
