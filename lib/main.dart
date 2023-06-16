import 'package:child_io/color.dart';
import 'package:child_io/home.dart';
import 'package:child_io/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool auth = true;
    return MaterialApp(
      title: 'child.io',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: auth ? AuthHome() : Home(),
    );
  }
}
