import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:idea_soop/screen/onboarding/CharacterSelectScreen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;

class KakaoLoginbutton extends StatelessWidget {
  const KakaoLoginbutton({Key? key}) : super(key: key);

  Future<void> _signInWithKakao(BuildContext context) async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token =
          isInstalled
              ? await UserApi.instance.loginWithKakaoTalk()
              : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.parse(
        'https://bb71-222-233-108-66.ngrok-free.app/auth/kakao',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'accessToken': token.accessToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //provide
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CharacterSelectScreen()),
        );
      } else {
        print('백엔드 인증 실패: ${response.body}');
      }
    } catch (e) {
      print('카카오 로그인 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _signInWithKakao(context),
      child: Image.asset(
        'assets/images/kakao_login.png',
        width: 280,
        height: 48,
      ),
    );
  }
}
