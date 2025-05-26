import 'package:flutter/material.dart';
import 'package:idea_soop/screen/home_screen.dart';
import 'package:idea_soop/screen/LoginScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'NanumSquareRound'),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
