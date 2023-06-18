import 'package:child_io/color.dart';
import 'package:child_io/home.dart';
import 'package:child_io/provider/auth_provider.dart';
import 'package:child_io/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => MaterialApp(
          title: 'child.io',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: primaryColor,
          ),
          home: FutureBuilder(
            future: authProvider.getAuthState(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  print(snapshot.data);
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null) {
                    return AuthHome();
                  }
                  return Home();
              }
            },
          ),
        ),
      ),
    );
  }
}
