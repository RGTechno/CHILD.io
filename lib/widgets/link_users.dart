import 'package:child_io/color.dart';
import 'package:flutter/material.dart';

Widget LinkAlertInp(String title) {
  return AlertDialog(
    title: Text(title),
    content: TextField(
      decoration: InputDecoration(
        hintText: "Enter User ID",
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    actions: <Widget>[
      TextButton(
        onPressed: () => {},
        child: const Text(
          'Cancel',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
      TextButton(
        onPressed: () {},
        child: const Text(
          'Link',
          style: TextStyle(
            color: textColor,
          ),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 20),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
  );
}
