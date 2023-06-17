import 'package:child_io/color.dart';
import 'package:flutter/material.dart';

class FriendsList extends StatelessWidget {
  final List friendsList;

  const FriendsList({required this.friendsList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, i) => Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text("NAME"), //TODO
          subtitle: Text("USER_ID"), //TODO
        ),
      ),
      itemCount: friendsList.length,
    );
  }
}
