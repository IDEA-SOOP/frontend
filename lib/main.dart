import 'package:flutter/material.dart';
import 'package:idea_soop/screen/onboarding/LoadingPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'NanumSquareRound'),
      home: LoadingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
