import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/home_screen.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyPageAppBar(),
              MyPageUserInfo(),
              MyPageLogCard(),
              MyPageTreeStateCard(),
              MyPageSettingCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNav(),
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
        padding: EdgeInsets.all(25),
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
  @override
  String? profileImageUrl; // 예: null 또는 'https://example.com/my.jpg'

  Widget build(BuildContext context) {
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
                    const Text(
                      "000님",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 7),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "내 정보 보기",
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.all(25),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _LogInfo(
                title: "씨앗 단계",
                subtitle: "1/4 단계",
                imgAsset: 'assets/images/seed0.png',
              ),
            ),
            SizedBox(
              height: 70,
              child: VerticalDivider(color: Colors.grey, thickness: 1),
            ),
            Expanded(
              child: _LogInfo(
                title: "답변/메모",
                subtitle: "5/15",
                imgAsset: 'assets/images/edit_note.png',
              ),
            ),
          ],
        ),
      ),
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
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Image.asset(imgAsset, height: 50, fit: BoxFit.fitHeight),
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
              SizedBox(height: 10),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyPageTreeStateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/seed0.png',
              height: 100,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(height: 15),
            Text(
              "오늘, 생각 한 알을 심었어요",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColorStrong,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15), ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _SettingRow(icon: Icons.dashboard, label: '내 카테고리', onTap: () {}),
              _SettingRow(icon: Icons.notifications_none, label: '알림 설정', onTap: () {}),
              _SettingRow(icon: Icons.help_outline, label: '도움말 / 지원', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
