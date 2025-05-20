import 'package:flutter/material.dart';
import 'package:idea_soop/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'NanumSquareRound',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

class AppColors {
  static const primary = Color(0xff369882);
  static const secondary = Color(0xff49AD94);
  static const background = Color(0xfffff6e4);
  static const textPrimary = Color(0xFF222222);
  static const textSecondary = Color(0x99262626); // 투명도 60
}
