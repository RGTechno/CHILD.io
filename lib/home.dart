import 'dart:convert';

import 'package:child_io/color.dart';
import 'package:child_io/constants.dart';
import 'package:child_io/provider/auth_provider.dart';
import 'package:child_io/screens/app_usage_screen.dart';
import 'package:child_io/screens/friends_screen.dart';
import 'package:child_io/screens/ranks_screen.dart';
import 'package:child_io/widgets/link_users.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isloading = false;

  var user;

  String parentID = "";

  Future<void> getLocationPermission() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (await location.isBackgroundModeEnabled()) {
      location.enableBackgroundMode(enable: true);
    }
  }

  Future<void> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var userData = await prefs.getString("user");
      var jsonUser = json.decode(userData!);
      setState(() {
        user = jsonUser;
      });
      print(user);
    } catch (err) {
      print(err);
    }
  }

  Future<void> getCoins() async {
    try {
      setState(() {
        _isloading = true;
      });
      var url = Uri.https(apiHost, "/api/child/coins", {
        "userID": user["userID"].toString(),
      });
      var response = await http.get(url);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
    } catch (err) {
      print(err);
    }
  }

  Future<void> linkParent() async {
    if (parentID.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    var userData = await prefs.getString("user");
    var jsonUser = json.decode(userData!);
    Navigator.of(context).pop();
    try {
      var url = Uri.https(
        apiHost,
        "/api/child/link-parent",
      );
      var response = await http.post(url,
          body: json.encode(
            {
              "userID": jsonUser["userID"],
              "parentID": int.parse(parentID),
            },
          ),
          headers: {'Content-Type': 'application/json'});
      print(response.body);
      var jsonResponse = json.decode(response.body);
      if (jsonResponse["success"]) {
        jsonUser["parentID"] = parentID;
      }
      await prefs.setString("user", json.encode(jsonUser));
      getUserData();
    } catch (err) {
      print(err);
    }
  }

  Future<void> init() async {
    await getUserData();
    // await getCoins();
  }

  int _selectedIndex = 0;

  @override
  void initState() {
    init();
    getLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      AppUsageScreen(),
      FriendsScreen(),
      RanksScreen(),
    ];
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: secondaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hey, ${user?["firstName"]}',
                    // overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: textColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'UserID - ${user?["userID"]}',
                      // overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: accentColor,
                      ),
                    ),
                  ),
                  user?["parentID"] == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Linked Parent ID - ${user?["parentID"]}',
                            // overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: accentColor,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            user?["parentID"] != null
                ? Container()
                : ListTile(
                    title: const Text('Link Parent'),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Link to Parent"),
                          content: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter User ID",
                            ),
                            onChanged: (value) {
                              setState(() {
                                parentID = value;
                              });
                            },
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await linkParent();
                              },
                              child: const Text(
                                'LINK',
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(horizontal: 20),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await context.read<AuthProvider>().logout();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.userFriends,
                text: 'Friends',
              ),
              GButton(
                icon: LineIcons.lineChart,
                text: 'Ranks',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
