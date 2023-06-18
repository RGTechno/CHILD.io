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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isloading = false;

  var user;

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

  Future<void> init() async {
    await getUserData();
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
                        color: Colors.red,
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
                        builder: (BuildContext context) =>
                            LinkAlertInp("Link to Parent"),
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
