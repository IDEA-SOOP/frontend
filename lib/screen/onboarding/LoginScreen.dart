import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/onboarding/CharacterSelectScreen.dart';
import 'package:idea_soop/screen/onboarding/KakaoLoginButton.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 상단 아이콘
              Image.asset(
                'assets/images/ideasoop.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 32),
              // 앱 이름
              const Text(
                '아이디어 숲',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColorFirst,
                ),
              ),
              const SizedBox(height: 16),
              // 설명 텍스트
              const Text(
                '작은 생각이 숲이 되도록,\n지금 함께 여정을 시작해요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: textColorFirst,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 56),
              // 카카오 로그인 버튼 placeholder
              const KakaoLoginbutton(),
            ],
          ),
        ),
      ),
    );
  }
}
