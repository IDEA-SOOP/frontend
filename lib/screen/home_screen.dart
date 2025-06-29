import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/HistoryView.dart';
import 'package:idea_soop/screen/MyPageScreen.dart';
import 'package:intl/intl.dart';
import 'package:idea_soop/services/api_service.dart';

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
  final String? nickname;
  final String? jwt;

  const HomeScreen({super.key, this.nickname, this.jwt});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAnswering = false;
  final TextEditingController _answerController = TextEditingController();
  String? _savedAnswer;

  // 질문 관련 상태
  int? _questionId;
  String? _questionContent;
  String? _questionAnswer;
  bool _isLoadingQuestion = true;

  @override
  void initState() {
    super.initState();
    _fetchTodayQuestion();
    print('HomeScreen에서 받은 JWT: ${widget.jwt}');
  }

  Future<void> _fetchTodayQuestion() async {
    setState(() {
      _isLoadingQuestion = true;
    });
    try {
      final data = await ApiService.fetchTodayQuestion(jwt: widget.jwt);
      setState(() {
        _questionId = data['questionId'];
        _questionContent = data['content'];
        _questionAnswer = data['answer'];
        _savedAnswer = data['answer'];
      });
    } catch (e) {
      print('질문 조회 실패: $e');
      setState(() {
        _questionContent = '질문을 불러오지 못했습니다.';
      });
    } finally {
      setState(() {
        _isLoadingQuestion = false;
      });
    }
  }

  Future<void> _submitAnswer() async {
    if (_questionId == null) return;
    final content = _answerController.text.trim();
    if (content.isEmpty) return;
    try {
      await ApiService.submitAnswer(
        questionId: _questionId!,
        content: content,
        jwt: widget.jwt,
      );
      setState(() {
        _savedAnswer = content;
        _isAnswering = false;
        _answerController.clear();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('답변이 저장되었습니다.')));
    } catch (e) {
      print('답변 저장 실패: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('답변 저장 실패: $e')));
    }
  }

  int _selectedIndex = 0;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = formatDateWithSuffix(now);

    return Scaffold(
      body: Column(
        children: [
          HomeAppBar(formattedDate: formattedDate, nickname: widget.nickname),
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
                    onSave: _submitAnswer,
                    onStartAnswer: () {
                      setState(() {
                        _isAnswering = true;
                        _answerController.clear();
                      });
                    },
                    onEditAnswer: () {
                      setState(() {
                        _isAnswering = true;
                        _answerController.text = _savedAnswer ?? '';
                      });
                    },
                    questionContent: _questionContent,
                    isLoadingQuestion: _isLoadingQuestion,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _selectedIndex,
        nickname: widget.nickname,
        jwt: widget.jwt,
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  final String formattedDate;
  final String? nickname;

  const HomeAppBar({super.key, required this.formattedDate, this.nickname});

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
                  Text(
                    "안녕하세요, ${nickname ?? '사용자'}님",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(formattedDate, style: const TextStyle(fontSize: 16)),
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
  final String? nickname;
  final String? jwt;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    this.nickname,
    this.jwt,
  });

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
                  MaterialPageRoute(
                    builder:
                        (context) => HomeScreen(nickname: nickname, jwt: jwt),
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/bottomicon_1.png',
                width: 35,
                height: 35,
              ),
            ),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryView(jwt: jwt),
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/bottomicon_22.png',
                width: 35,
                height: 35,
              ),
            ),
            label: "idea block",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryView(jwt: jwt),
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/bottomicon_3.png',
                width: 35,
                height: 35,
              ),
            ),
            label: "community",
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPageScreen(jwt: jwt),
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/bottomicon_4.png',
                width: 35,
                height: 35,
              ),
            ),
            label: "user",
          ),
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
  final String? questionContent;
  final bool isLoadingQuestion;

  const HomeQuestionCard({
    super.key,
    required this.isAnswering,
    required this.savedAnswer,
    required this.answerController,
    required this.onCancel,
    required this.onSave,
    required this.onStartAnswer,
    required this.onEditAnswer,
    this.questionContent,
    this.isLoadingQuestion = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
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
          Row(
            children: [
              Expanded(
                child: const Text(
                  "오늘의 질문",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              if (!isAnswering)
                IconButton(
                  onPressed:
                      (savedAnswer == null || savedAnswer == "")
                          ? onStartAnswer
                          : onEditAnswer,
                  icon: Icon(Icons.edit_rounded),
                ),
            ],
          ),
          const SizedBox(height: 15),
          isLoadingQuestion
              ? const Center(child: CircularProgressIndicator())
              : Text(
                questionContent ?? "질문이 없습니다.",
                style: const TextStyle(fontSize: 16),
              ),
          const SizedBox(height: 12),

          if (savedAnswer == null || savedAnswer == "") ...[
            if (!isAnswering)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: textColorThird, height: 10),
                  SizedBox(height: 12),
                  Text(
                    "오늘은 어떤 생각이 떠오르셨나요?\n한 줄 남겨보세요.",
                    style: TextStyle(color: textColorThird, fontSize: 12),
                  ),
                ],
              )
            else
              Column(
                children: [
                  SizedBox(height: 12),
                  _AnswerField(
                    controller: answerController,
                    onCancel: onCancel,
                    onSave: onSave,
                    isEdit: false,
                  ),
                ],
              ),
          ] else ...[
            if (!isAnswering) ...[
              Divider(color: textColorThird, height: 10),
              SizedBox(height: 15),
              Text(
                savedAnswer!,
                style: const TextStyle(fontSize: 16, color: textColorFirst),
              ),
            ] else
              _AnswerField(
                controller: answerController,
                onCancel: onCancel,
                onSave: onSave,
                isEdit: true,
              ),
          ],
          SizedBox(height: 15),
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
        Container(
          decoration: BoxDecoration(
            color: backgroundColorStrong,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
              hintText: isEdit ? null : "여기에 당신의 생각을 자유롭게 적어보세요.",
              hintStyle: const TextStyle(fontSize: 13, color: textColorThird),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ElevatedButton(
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
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pointColorStrong,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: activatedNextbuttonColor),
                  ),
                ),
                child: Text(
                  isEdit ? '수정' : '확인',
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
