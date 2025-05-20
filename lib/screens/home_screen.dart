import 'package:flutter/material.dart';
import 'package:idea_soop/main.dart';
import 'package:intl/intl.dart';

//  날짜 서수 접미사 함수
String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) return 'th';
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

//  날짜 포맷팅 함수
String formatDateWithSuffix(DateTime date) {
  final month = DateFormat('MMMM').format(date);
  final day = date.day;
  final year = date.year;
  final suffix = getDaySuffix(day);
  return '$month $day$suffix, $year';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAnswering = false;
  final TextEditingController _answerController = TextEditingController();

  String? _savedAnswer;

  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final now = DateTime.now();
    final formattedDate = formatDateWithSuffix(now);

    return Scaffold(
      body: Column(
        children: [
          //  상단 인사 영역, 설정 버튼
          Container(
            width: double.infinity,
            height: 150,
            color: AppColors.background,
            child: Container(
              margin: EdgeInsets.fromLTRB(25, 70, 25, 10),
              child: Row(
                children: [
                  Container(
                    width: screenWidth - 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "안녕하세요, 00님",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.settings),
                    iconSize: 30,
                    padding: EdgeInsets.all(5),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/home_screen_background.png',
                    fit: BoxFit.cover,
                  ),
                ),

                SingleChildScrollView(
                  //  오늘의 질문
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "오늘의 질문",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "최근 가장 영감을 준 일은 무엇인가요?",
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 15),

                        if (_savedAnswer == null || _savedAnswer == "") ...[
                          //   1. 저장된 답변이 없을 때
                          if (!_isAnswering) ...[
                            //  1-1. 작성중이 아니면 답변작성 버튼 표시
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isAnswering = true;
                                  _answerController.clear();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.black),
                                ),
                              ),
                              child: Center(
                                child: const Text(
                                  "답변 작성",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ] else ...[
                            // 1-2. 답변 작성 중
                            TextField(
                              controller: _answerController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  
                                ),
                                hintText: "여기에 당신의 생각을 자유롭게 적어보세요.",
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isAnswering = false;
                                      _answerController.clear();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.background,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  child: const Text(
                                    '취소',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      // print('저장할 답변: ${_answerController.text}');
                                      _savedAnswer = _answerController.text;
                                      _isAnswering = false;
                                      _answerController.clear();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  child: const Text(
                                    '등록',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ] else ...[
                          //  저장된 답변이 있을 때
                          if (!_isAnswering) ...[
                            //  작성중이 아닐 때 기존 답변, 답변 수정 버튼 표시
                            Divider(
                              color: Colors.grey, // 선 색상
                              thickness: 1, // 선 두께
                              indent: 0, // 왼쪽 여백
                              endIndent: 0, // 오른쪽 여백
                            ),
                            Text(
                              _savedAnswer!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isAnswering = true;
                                      _answerController.text = _savedAnswer!;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  child: const Text(
                                    "수정",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            TextField(
                              controller: _answerController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isAnswering = false;
                                      _answerController.clear();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.background,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  child: const Text(
                                    '취소',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _savedAnswer = _answerController.text;
                                      _isAnswering = false;
                                      _answerController.clear();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  child: const Text(
                                    '수정',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 하단 바
      bottomNavigationBar: SizedBox(
        height: 90,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.forest_rounded),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: "idea block",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "community",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "user"),
          ],
          backgroundColor: AppColors.background,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey[500],
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
