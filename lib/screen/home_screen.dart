import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/HistoryView.dart';
import 'package:intl/intl.dart';

// 날짜 서수 접미사 함수
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

String formatDateWithSuffix(DateTime date) {
  final month = DateFormat('MMMM').format(date);
  final day = date.day;
  final year = date.year;
  final suffix = getDaySuffix(day);
  return '$month $day$suffix, $year';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAnswering = false;
  final TextEditingController _answerController = TextEditingController();
  String? _savedAnswer;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = formatDateWithSuffix(now);

    return Scaffold(
      body: Column(
        children: [
          HomeAppBar(formattedDate: formattedDate),
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
                  child: HomeQuestionCard(
                    isAnswering: _isAnswering,
                    savedAnswer: _savedAnswer,
                    answerController: _answerController,
                    onCancel: () {
                      setState(() {
                        _isAnswering = false;
                        _answerController.clear();
                      });
                    },
                    onSave: () {
                      setState(() {
                        _savedAnswer = _answerController.text;
                        _isAnswering = false;
                        _answerController.clear();
                      });
                    },
                    onStartAnswer: () {
                      setState(() {
                        _isAnswering = true;
                        _answerController.clear();
                      });
                    },
                    onEditAnswer: () {
                      setState(() {
                        _isAnswering = true;
                        _answerController.text = _savedAnswer!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNav(currentIndex: _selectedIndex),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  final String formattedDate;
  const HomeAppBar({super.key, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      color: backgroundColor,
      child: Container(
        margin: const EdgeInsets.fromLTRB(25, 70, 25, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "안녕하세요, 00님",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
              iconSize: 30,
              padding: const EdgeInsets.all(5),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeBottomNav extends StatelessWidget {
  final int currentIndex;

  const HomeBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              icon: const Icon(Icons.forest_rounded),
            ),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryView()),
                );
              },
              icon: Icon(Icons.description_outlined),
            ),
            label: "idea block",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.people), label: "community"),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "user"),
        ],
        backgroundColor: backgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: pointColorStrong,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

class HomeQuestionCard extends StatelessWidget {
  final bool isAnswering;
  final String? savedAnswer;
  final TextEditingController answerController;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final VoidCallback onStartAnswer;
  final VoidCallback onEditAnswer;

  const HomeQuestionCard({
    super.key,
    required this.isAnswering,
    required this.savedAnswer,
    required this.answerController,
    required this.onCancel,
    required this.onSave,
    required this.onStartAnswer,
    required this.onEditAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      decoration: BoxDecoration(
        color: backgroundColor,
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const Text("최근 가장 영감을 준 일은 무엇인가요?", style: TextStyle(fontSize: 13)),
          const SizedBox(height: 15),
          if (savedAnswer == null || savedAnswer == "") ...[
            if (!isAnswering)
              ElevatedButton(
                onPressed: onStartAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pointColorStrong,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                child: const Center(
                  child: Text("답변 작성", style: TextStyle(color: Colors.white)),
                ),
              )
            else
              _AnswerField(
                controller: answerController,
                onCancel: onCancel,
                onSave: onSave,
                isEdit: false,
              ),
          ] else ...[
            if (!isAnswering) ...[
              const Divider(color: Colors.grey, thickness: 1),
              Text(
                savedAnswer!,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: onEditAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pointColorStrong,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: const Text(
                      "수정",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ] else
              _AnswerField(
                controller: answerController,
                onCancel: onCancel,
                onSave: onSave,
                isEdit: true,
              ),
          ],
        ],
      ),
    );
  }
}

class _AnswerField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isEdit;

  const _AnswerField({
    required this.controller,
    required this.onCancel,
    required this.onSave,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: isEdit ? null : "여기에 당신의 생각을 자유롭게 적어보세요.",
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child: const Text(
                '취소',
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: pointColorStrong,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child: Text(
                isEdit ? '수정' : '등록',
                style: const TextStyle(fontSize: 13, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
