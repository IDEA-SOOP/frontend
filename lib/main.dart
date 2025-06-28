import 'package:flutter/material.dart';
import 'package:idea_soop/screen/onboarding/LoadingPage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<void> main() async {
  KakaoSdk.init(nativeAppKey: '네이티브~');
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
