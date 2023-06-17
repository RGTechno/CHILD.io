import 'package:child_io/color.dart';
import 'package:child_io/widgets/friends_list.dart';
import 'package:child_io/widgets/header.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8,
      ),
      child: Column(
        children: [
          Header(300, mediaQuery.height * 0.05),
          TabBar(
            unselectedLabelColor: secondaryColor,
            labelColor: primaryColor,
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
                FriendsList(friendsList: allFriends),
                // current accepted friends from both parties
                FriendsList(friendsList: sentFriendsRequest),
                // sent friend request
                FriendsList(friendsList: receivedFriendsRequest),
                // received friend requests
              ],
              controller: _tabController,
            ),
          ),
        ],
      ),
    );
  }
}
