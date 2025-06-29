import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyPageScreen extends StatefulWidget {
  final String? jwt;

  const MyPageScreen({super.key, this.jwt});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  int _selectedIndex = 3;
  late Future<UserProfile> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FutureBuilder<UserProfile>(
          future: futureProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("에러 발생: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final profile = snapshot.data!;
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 90,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        MyPageAppBar(),
                        Divider(color: Colors.grey.withOpacity(0.2)),
                        MyPageUserInfo(profile: profile), // ✅ 전달!
                        MyPageLogCard(profile: profile),
                        Spacer(),
                        MyPageSettingCard(),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: Text("데이터 없음"));
            }
          },
        ),
      ),

      bottomNavigationBar: HomeBottomNav(currentIndex: _selectedIndex),
    );
  }
}

class MyPageAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: const Text(
                "마이 페이지",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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

class MyPageUserInfo extends StatelessWidget {
  final UserProfile profile;

  const MyPageUserInfo({super.key, required this.profile});
  // @override
  // String? profileImageUrl; // 예: null 또는 'https://example.com/my.jpg'

  Widget build(BuildContext context) {
    final profileImageUrl = "assets/images/bear.png";

    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[400],
              backgroundImage:
                  profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : null,
              child:
                  profileImageUrl == null
                      ? Icon(Icons.person, size: 30, color: Colors.black)
                      : null,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(40, 10, 0, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${profile.nickname}님",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 7),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "함께한지 ${profile.daysSinceJoin}일째",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPageLogCard extends StatelessWidget {
  final UserProfile profile;

  const MyPageLogCard({super.key, required this.profile});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: pointColorWeak.withOpacity(0.4),
          borderRadius: BorderRadius.circular(32),
        ),

        child: Column(
          children: [
            MyPageTreeStateCard(profile: profile),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _LogInfo(
                    title: "씨앗 단계",
                    subtitle: "${profile.seedStage}/4 단계",
                    imgAsset: 'assets${profile.seedStageImageUrl}',
                  ),
                ),
                SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      iconSize: 17,
                      onPressed: () => popSeedStep(context),
                      icon: Icon(Icons.info_outline),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(), // 불필요한 여백 제거
                    ),
                    SizedBox(
                      height: 70,
                      child: VerticalDivider(thickness: 1, color: Colors.grey),
                    ),
                    SizedBox(width: 17),
                  ],
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _LogInfo(
                    title: "답변/메모",
                    subtitle: "${profile.answerCount}/${profile.memoCount}",
                    imgAsset: 'assets/images/note_alt.png',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void popSeedStep(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 클릭 시 닫기 여부
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: backgroundColor, // 완전 투명 배경도 가능
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '씨앗 단계',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset('assets/images/seed0.png', width: 40),
                      Image.asset('assets/images/seed1.png', width: 50),
                      Image.asset('assets/images/seed2.png', width: 60),
                      Image.asset('assets/images/seed3.png', width: 60),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '작은 생각 하나가 씨앗이 돼요.\n씨앗을 키워서 나무 한 그루를 완성해보세요!',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pointColorStrong,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('확인', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LogInfo extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgAsset;

  const _LogInfo({
    required this.title,
    required this.subtitle,
    required this.imgAsset,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 55, maxWidth: 100),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 50),
              child: Image.asset(imgAsset, fit: BoxFit.fitHeight),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyPageTreeStateCard extends StatelessWidget {
  final UserProfile profile;

  const MyPageTreeStateCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets${profile.seedStageImageUrl}',
              height: 60,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(height: 15),
            Text(
              "${profile.seedDescription}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPageSettingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: backgroundColor),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _SettingRow(
                asset: 'assets/images/category.png',
                label: '내 카테고리',
                onTap: () {},
              ),
              _SettingRow(
                asset: 'assets/images/notification.png',
                label: '알림 설정',
                onTap: () {},
              ),
              _SettingRow(
                asset: 'assets/images/message-question.png',
                label: '도움말 / 지원',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String asset;
  final String label;
  final VoidCallback onTap;

  const _SettingRow({
    required this.asset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        child: Row(
          children: [
            Image.asset(asset, width: 25, height: 25, fit: BoxFit.fill),
            SizedBox(width: 20),
            Expanded(child: Text(label, style: TextStyle(fontSize: 16))),
            Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

class UserProfile {
  final String nickname;
  final int daysSinceJoin;
  final int seedStage;
  final String seedStageImageUrl;
  final String seedDescription;
  final int answerCount;
  final int memoCount;
  final int level;

  UserProfile({
    required this.nickname,
    required this.daysSinceJoin,
    required this.seedStage,
    required this.seedStageImageUrl,
    required this.seedDescription,
    required this.answerCount,
    required this.memoCount,
    required this.level,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'],
      daysSinceJoin: json['daysSinceJoin'],
      seedStage: json['seedStage'],
      seedStageImageUrl: json['seedStageImageUrl'],
      seedDescription: json['seedDescription'],
      answerCount: json['answerCount'],
      memoCount: json['memoCount'],
      level: json['level'],
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

  final url = Uri.parse('https://870f-211-59-211-217.ngrok-free.app/mypage');
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
