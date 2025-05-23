import 'package:flutter/material.dart';
import 'package:idea_soop/screen/CharacterSelectScreen.dart';
import 'package:idea_soop/const/Colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3E7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Top(),
                  const SizedBox(height: 60),
                  GeneralLogin(),
                  const SizedBox(height: 24),
                  LoginButton(),
                  const SizedBox(height: 24),
                  SocialLogin(),
                  const SizedBox(height: 32),
                  SignUpLogin(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GeneralLogin extends StatelessWidget {
  const GeneralLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            hintText: 'Your Password',
            hintStyle: TextStyle(fontFamily: 'Poppins'),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline),
            hintText: 'Your Email/id',
            hintStyle: TextStyle(fontFamily: 'Poppins'),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final String asset;
  const _SocialIcon({required this.asset});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.white,
      child: Image.asset(asset, width: 56, height: 56, fit: BoxFit.fill),
    );
  }
}

class Top extends StatelessWidget {
  const Top({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '아이디어 숲',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumSquareRound',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '당신의 생각을 심고, 나만의 숲을 키워보세요',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: 'NanumSquareRound',
          ),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CharacterSelectScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: pointColorStrong,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 22, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Or Sign In With',
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SocialIcon(asset: 'assets/images/google_icon.png'),
            _SocialIcon(asset: 'assets/images/kakao_icon.png'),
            _SocialIcon(asset: 'assets/images/naver_icon.png'),
          ],
        ),
      ],
    );
  }
}

class SignUpLogin extends StatelessWidget {
  const SignUpLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Color(0xFF00B8D9),
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
