import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/onboarding/TopicSelectScreen.dart';

class CharacterSelectScreen extends StatefulWidget {
  const CharacterSelectScreen({super.key});

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen> {
  String? selectedCharacter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                '캐릭터를 골라주세요',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColorFirst,
                  fontFamily: 'NanumSquareRound',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                '[내 캐릭터]에서 언제든지 변경할 수 있어요',
                style: const TextStyle(
                  fontSize: 16,
                  color: textColorThird,
                  fontFamily: 'NanumSquareRound',
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CharacterCard(
                  image: 'assets/images/bear.png',
                  label: '곰',
                  selected: selectedCharacter == '곰',
                  onTap: () {
                    setState(() {
                      selectedCharacter = '곰';
                    });
                  },
                ),
                _CharacterCard(
                  image: 'assets/images/fox.png',
                  label: '여우',
                  selected: selectedCharacter == '여우',
                  onTap: () {
                    setState(() {
                      selectedCharacter = '여우';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 48),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: SizedBox(
                  width: 300,
                  height: 45,
                  child: ElevatedButton(
                    onPressed:
                        selectedCharacter == null
                            ? null
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const TopicSelectScreen(),
                                ),
                              );
                            },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return unactivatedNextbuttonColor;
                          }
                          return activatedNextbuttonColor;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'NanumSquareRound',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TopicSelectScreen(),
                    ),
                  );
                },
                child: const Text(
                  '건너뛰기',
                  style: TextStyle(
                    color: textColorThird,
                    fontSize: 12,
                    fontFamily: 'NanumSquareRound',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final String image;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CharacterCard({
    required this.image,
    required this.label,
    required this.selected,
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
          color: selected ? selectedButtonColor : unselectedButtonColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 64, height: 64),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: textColorFirst,
                fontFamily: 'NanumSquareRound',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
