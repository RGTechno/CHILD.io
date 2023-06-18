import 'dart:convert';

import 'package:child_io/color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class FriendsList extends StatelessWidget {
  final List friendsList;
  final bool isReceived;
  final Function refresh;

  const FriendsList(
      {required this.friendsList,
      required this.isReceived,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    Future<void> acceptRequest(int sId) async {
      final prefs = await SharedPreferences.getInstance();
      var userData = await prefs.getString("user");
      var jsonUser = json.decode(userData!);
      try {
        var url = Uri.https(
          apiHost,
          "/api/child/friends/accept",
        );
        var response = await http.post(url,
            body: json.encode(
              {
                "senderUserID": sId,
                "receiverUserID": jsonUser["userID"],
              },
            ),
            headers: {'Content-Type': 'application/json'});
        print(response.body);
        var jsonResponse = json.decode(response.body);
        Fluttertoast.showToast(
          msg: jsonResponse["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
        );
        refresh();
      } catch (err) {
        print(err);
      }
    }

    return ListView.builder(
      itemBuilder: (ctx, index) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Text(friendsList[index]["firstName"] +
                " " +
                friendsList[index]["lastName"]),
            subtitle:
                Text("UserID - ${friendsList[index]["userID"].toString()}"),
            trailing: isReceived
                ? IconButton(
                    onPressed: () async {
                      await acceptRequest(friendsList[index]["userID"]);
                    },
                    icon: Icon(Icons.check))
                : Text(""),
          ),
        ),
      ),
      itemCount: friendsList.length,
    );
  }
}
