import 'package:flutter/material.dart';

Widget LinkAlertInp(String title) {
  return AlertDialog(
    title: Text(title),
    content: TextField(
      decoration: InputDecoration(
        hintText: "Enter User ID",
      ),
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () => {},
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => {},
        child: const Text('Link'),
      ),
    ],
  );
}
