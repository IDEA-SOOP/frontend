import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/home_screen.dart';

class StartView extends StatelessWidget {
  final String nickname;
  const StartView({super.key, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                '$nickname님,\n환영합니다!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColorFirst,
                  fontFamily: 'NanumSquareRound',
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/images/startview.png',
                width: 353,
                height: 257,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(nickname: nickname),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      activatedNextbuttonColor,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text(
                    '시작하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'NanumSquareRound',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
