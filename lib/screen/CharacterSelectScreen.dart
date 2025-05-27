import 'package:flutter/material.dart';
import 'package:idea_soop/screen/TopicSelectScreen.dart';

class CharacterSelectScreen extends StatelessWidget {
  const CharacterSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3E7),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Top(),
            const SizedBox(height: 60),
            CharacterSelection(),
            const Spacer(),
            SkipButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const _CharacterCard({
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFFDF8ED),
          border: Border.all(color: const Color(0xFFBDBDBD)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 64, height: 64),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF444444),
                fontFamily: 'NanumSquareRound',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Top extends StatelessWidget {
  const Top({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: LinearProgressIndicator(
            value: 0.5,
            backgroundColor: const Color(0xFFE5DED6),
            color: const Color(0xFFC7C7B6),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 60),
        const Center(
          child: Text(
            "“당신의 캐릭터를 골라주세요”",
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFF444444),
              fontWeight: FontWeight.w500,
              fontFamily: 'NanumSquareRound',
            ),
          ),
        ),
      ],
    );
  }
}

class CharacterSelection extends StatelessWidget {
  const CharacterSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CharacterCard(
          image: 'assets/images/man_icon.png',
          label: '남자',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TopicSelectScreen(),
              ),
            );
          },
        ),
        _CharacterCard(
          image: 'assets/images/woman_icon.png',
          label: '여자',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TopicSelectScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // 건너뛰기 동작
      },
      child: const Text(
        '건너뛰기',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontFamily: 'NanumSquareRound',
        ),
      ),
    );
  }
}
