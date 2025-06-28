import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/onboarding/LoginScreen.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9E3),
      body: SafeArea(
        child: Stack(
          children: [
            // 중앙 아이콘 + 타이틀
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/ideasoop.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'IDEA SOOP',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColorFirst,
                    ),
                  ),
                ],
              ),
            ),
            // 하단 슬로건
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: const Text(
                '작은 생각이 숲이 될 때까지',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: textColorFirst),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
