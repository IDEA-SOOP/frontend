import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/home_screen.dart';

class TopicSelectScreen extends StatelessWidget {
  const TopicSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3E7),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // 진행 바
            Top(),
            const SizedBox(height: 40),
            TopicSelection(),
            BottomButtons(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final String icon;
  final String label;

  const _TopicCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8ED),
        border: Border.all(color: const Color(0xFFBDBDBD)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, width: 48, height: 48),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF444444),
              fontFamily: 'NanumSquareRound',
            ),
          ),
        ],
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
            value: 0.8,
            backgroundColor: const Color(0xFFE5DED6),
            color: const Color(0xFFC7C7B6),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 40),
        const Center(
          child: Text(
            '“어떤 이야기를 더 자주\n나누고 싶으신가요?”',
            textAlign: TextAlign.center,
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

class TopicSelection extends StatelessWidget {
  const TopicSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 1.1,
          children: const [
            _TopicCard(icon: 'assets/images/work.png', label: '일 / 커리어'),
            _TopicCard(icon: 'assets/images/talk.png', label: '관계 / 소통'),
            _TopicCard(icon: 'assets/images/talk.png', label: '가치 / 철학'),
            _TopicCard(icon: 'assets/images/idea.png', label: '상상 / 창작'),
            _TopicCard(icon: 'assets/images/talk.png', label: '배움 / 탐구'),
            _TopicCard(icon: 'assets/images/talk.png', label: '일상 / 취향'),
          ],
        ),
      ),
    );
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: pointColorStrong,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              child: const Text(
                '다음',
                style: TextStyle(fontSize: 20, fontFamily: 'NanumSquareRound'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
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
        ),
      ],
    );
  }
}
