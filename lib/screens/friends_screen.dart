import 'dart:convert';

import 'package:child_io/color.dart';
import 'package:child_io/constants.dart';
import 'package:child_io/widgets/friends_list.dart';
import 'package:child_io/widgets/header.dart';
import 'package:child_io/widgets/link_users.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late TabController _tabController;

  bool _isLoading = false;

  List allFriends = [
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
  ];
  List sentFriendsRequest = [
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
  ];
  List receivedFriendsRequest = [
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
    "jdnjds",
  ];

  Future<void> getFriends() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final prefs = await SharedPreferences.getInstance();
      var userData = await prefs.getString("user");
      var jsonUser = json.decode(userData!);
      var url = Uri.https(
        apiHost,
        "/api/child/friends",
        {"userID": jsonUser["userID"].toString()},
      );
      var response = await http.get(url);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse["success"]) {
        setState(() {
          allFriends = jsonResponse["data"]["confirmed"];
          sentFriendsRequest = jsonResponse["data"]["outgoing"];
          receivedFriendsRequest = jsonResponse["data"]["incoming"];
          _isLoading = false;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> init() async {
    await getFriends();
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    init();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) =>
                      LinkAlertInp("Link to Friend"),
                );
              },
              backgroundColor: primaryColor,
              child: Icon(Icons.add),
            ),
            body: RefreshIndicator(
              onRefresh: init,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 8,
                ),
                child: Column(
                  children: [
                    Header(
                      300,
                      mediaQuery.height * 0.05,
                      context: context,
                    ),
                    TabBar(
                      unselectedLabelColor: textColor,
                      labelColor: Color(0xff536599),
                      tabs: [
                        Tab(
                          text: 'Friends',
                        ),
                        Tab(
                          text: 'Sent',
                        ),
                        Tab(
                          text: 'Received',
                        )
                      ],
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                    SizedBox(height: mediaQuery.height * 0.02),
                    Expanded(
                      child: TabBarView(
                        children: [
                          FriendsList(
                            friendsList: allFriends,
                            isReceived: false,
                            refresh: (){},
                          ),
                          // current accepted friends from both parties
                          FriendsList(
                            friendsList: sentFriendsRequest,
                            isReceived: false,
                            refresh: (){},
                          ),
                          // sent friend request
                          FriendsList(
                            friendsList: receivedFriendsRequest,
                            isReceived: true,
                            refresh: getFriends,
                          ),
                          // received friend requests
                        ],
                        controller: _tabController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
