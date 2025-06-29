import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/home_screen.dart';

class MyPageScreen extends StatefulWidget {
  final String? jwt;

  const MyPageScreen({super.key, this.jwt});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  90, // 90: bottom nevigation bar's height
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  MyPageAppBar(),
                  Divider(color: Colors.grey.withOpacity(0.2)),
                  MyPageUserInfo(),
                  MyPageLogCard(),
                  Spacer(),
                  MyPageSettingCard(),
                ],
              ),
            ),
          ),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 7),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "함께한지 nn일째",
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
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColorStrong,
          borderRadius: BorderRadius.circular(32),
        ),

        child: Column(
          children: [
            MyPageTreeStateCard(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _LogInfo(
                    title: "씨앗 단계",
                    subtitle: "1/4 단계",
                    imgAsset: 'assets/images/seed0.png',
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
                    subtitle: "5/15",
                    imgAsset: 'assets/images/edit_note.png',
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
              height: 60,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(height: 15),
            Text(
              "오늘, 생각 한 알을 심었어요",
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
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColorStrong,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _SettingRow(icon: Icons.dashboard, label: '내 카테고리', onTap: () {}),
              _SettingRow(
                icon: Icons.notifications_none,
                label: '알림 설정',
                onTap: () {},
              ),
              _SettingRow(
                icon: Icons.help_outline,
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
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingRow({
    required this.icon,
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
            Icon(icon, color: Colors.black87),
            SizedBox(width: 20),
            Expanded(child: Text(label, style: TextStyle(fontSize: 16))),
            Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
