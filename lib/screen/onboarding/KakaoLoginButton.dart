import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:idea_soop/screen/onboarding/CharacterSelectScreen.dart';
import 'package:idea_soop/services/api_service.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KakaoLoginbutton extends StatelessWidget {
  const KakaoLoginbutton({Key? key}) : super(key: key);

  Future<void> _signInWithKakao(BuildContext context) async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token =
          isInstalled
              ? await UserApi.instance.loginWithKakaoTalk()
              : await UserApi.instance.loginWithKakaoAccount();

      // 새로운 API 서비스 사용
      final response = await ApiService.kakaoLogin(token.accessToken);

      // 응답에서 필요한 정보 추출
      final userId = response['userId'];
      final status = response['status'];
      final nickname = response['nickname'];
      final jwt = response['jwt'];

      // JWT 토큰을 저장하거나 관리하는 로직 추가 가능
      // SharedPreferences 등을 사용하여 토큰 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', jwt);

      print('로그인 성공: userId=$userId, status=$status, nickname=$nickname');
      print("내 토큰: $jwt");

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CharacterSelectScreen(userId: userId, jwt: jwt),
        ),
      );
    } catch (e) {
      print('카카오 로그인 실패: $e');
      // 에러 처리 UI 추가 가능
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('로그인에 실패했습니다: $e')));
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
