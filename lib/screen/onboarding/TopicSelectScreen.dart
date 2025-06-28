import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/onboarding/NameSelectScreen.dart';

class TopicSelectScreen extends StatefulWidget {
  final int? userId;
  final String? jwt;
  final int selectedCharacterId;

  const TopicSelectScreen({
    super.key,
    this.userId,
    this.jwt,
    this.selectedCharacterId = 1,
  });

  @override
  State<TopicSelectScreen> createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  final List<String> topics = [
    '일 / 커리어',
    '관계 / 소통',
    '상상 / 창작',
    '가치 / 철학',
    '배움 / 독서',
    '일상 / 취향',
  ];
  final List<String> icons = [
    'assets/images/business_center.png',
    'assets/images/handshake.png',
    'assets/images/lightbulb.png',
    'assets/images/interests.png',
    'assets/images/auto_stories.png',
    'assets/images/favorite.png',
  ];
  final Set<int> selectedIndexes = {};

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
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                '질문 카테고리를 선택해 주세요',
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
                '[마이페이지]에서 언제든지 변경할 수 있어요',
                style: const TextStyle(
                  fontSize: 16,
                  color: textColorThird,
                  fontFamily: 'NanumSquareRound',
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: GridView.builder(
                  itemCount: topics.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, idx) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedIndexes.contains(idx)) {
                            selectedIndexes.remove(idx);
                          } else {
                            selectedIndexes.add(idx);
                          }
                        });
                      },
                      child: _TopicCard(
                        icon: icons[idx],
                        label: topics[idx],
                        selected: selectedIndexes.contains(idx),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: SizedBox(
                  width: 300,
                  height: 45,
                  child: ElevatedButton(
                    onPressed:
                        selectedIndexes.isEmpty
                            ? null
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => NicknameSelectScreen(
                                        userId: widget.userId,
                                        jwt: widget.jwt,
                                        selectedCategoryIds:
                                            selectedIndexes
                                                .map((index) => index + 1)
                                                .toList(),
                                        selectedCharacterId:
                                            widget.selectedCharacterId,
                                      ),
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
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NanumSquareRound',
                        color: Colors.white,
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
                      builder:
                          (context) => NicknameSelectScreen(
                            userId: widget.userId,
                            jwt: widget.jwt,
                            selectedCategoryIds: [1, 2, 3, 4, 5, 6],
                            selectedCharacterId: widget.selectedCharacterId,
                          ),
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
  final bool selected;

  const _TopicCard({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 120,
      decoration: BoxDecoration(
        color: selected ? selectedButtonColor : unselectedButtonColor,
        borderRadius: BorderRadius.circular(32),
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
              color: textColorFirst,
              fontFamily: 'NanumSquareRound',
            ),
          ),
        ],
      ),
    );
  }
}
