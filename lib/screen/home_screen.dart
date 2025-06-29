import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/CharacterScreen.dart';
import 'package:idea_soop/screen/HistoryView.dart';
import 'package:idea_soop/screen/MyPageScreen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  late Future<UserProfile> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = fetchUserProfile(); 
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = formatDateWithSuffix(now);

    return FutureBuilder<UserProfile>( 
      future: futureProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("에러 발생: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final profile = snapshot.data!;
          return Scaffold(
            body: Column(
              children: [
                HomeAppBar( // 변경됨
                  formattedDate: formattedDate,
                  profile: profile,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/background0.png',
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.fill,
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
                      Positioned(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                            child: Image.asset('assets${profile.mainAnimalImageUrl}'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: HomeBottomNav(currentIndex: _selectedIndex),
          );
        } else {
          return const Center(child: Text("데이터 없음"));
        }
      },
    );
  }
}

class HomeAppBar extends StatelessWidget {
  final String formattedDate;
  final UserProfile profile; // 변경됨

  const HomeAppBar({
    super.key,
    required this.formattedDate,
    required this.profile, // 변경됨
  });

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
                    "안녕하세요, ${profile.nickname}님", // 변경됨
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(formattedDate,
                      style: const TextStyle(fontSize: 16)),
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
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryView()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CharacterScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPageScreen()),
              );
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottomicon_1.png',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            activeIcon: Image.asset(
              'assets/images/bottomicon_1s.png',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottomicon_22.png',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            activeIcon: Image.asset(
              'assets/images/bottomicon_2s.png',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            label: "history view",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottomicon_3.png',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            activeIcon: Image.asset(
              'assets/images/bottomicon_3s.png',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            label: "style",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottomicon_4.png',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
            activeIcon: Image.asset(
              'assets/images/bottomicon_4s.png',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
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
          const Text("최근 가장 영감을 준 일은 무엇인가요?", style: TextStyle(fontSize: 16)),
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

class UserProfile {
  final String nickname;
  final String mainAnimalImageUrl;

  UserProfile({required this.nickname, required this.mainAnimalImageUrl});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'],
      mainAnimalImageUrl: json['mainAnimalImageUrl'],
    );
  }
}

Future<String?> loadToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

Future<UserProfile> fetchUserProfile() async {
  final prefs = await SharedPreferences.getInstance();
  final jwt = prefs.getString('accessToken');

  final url = Uri.parse('https://870f-211-59-211-217.ngrok-free.app/home/userinfo');
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $jwt'},
  );

  print("내 토큰: $jwt");
  print('응답 상태 코드: ${response.statusCode}');
  print('응답 본문: ${response.body}');

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return UserProfile.fromJson(jsonData);
  } else {
    throw Exception('유저 정보를 불러오지 못했습니다.');
  }
}
