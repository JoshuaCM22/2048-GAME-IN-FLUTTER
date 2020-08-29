import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: '2048',
      theme: new ThemeData(
          primarySwatch: Colors.deepOrange,
          primaryTextTheme:
              TextTheme(headline6: TextStyle(color: Colors.white))),
      home: HomeScreen(),
    );
  }
}
