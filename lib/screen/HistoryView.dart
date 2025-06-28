import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/HistoryViewSearch.dart';
import 'package:idea_soop/screen/home_screen.dart';
import 'package:idea_soop/services/api_service.dart';

class HistoryView extends StatefulWidget {
  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String selectedSource = '모두';

  // // 임시 메모 데이터
  // final List<Map<String, String>> memos = [
  //   {
  //     'date': '2025.05.19',
  //     'type': '오늘의 질문',
  //     'source': '질문에 대한 답변',
  //     'title': '요즘 나를 가장 괴롭히는 생각은?',
  //     'content': '타인의 시선을 너무 신경쓰게 되는 요즘...',
  //     'tags': '#자존감 #괴로운생각 #메모',
  //   },
  //   {
  //     'date': '2025.05.20',
  //     'type': '음성녹음',
  //     'source': '메모',
  //     'title': '요즘 나를 가장 괴롭히는 생각은?',
  //     'content': '타인의 시선을 너무 신경쓰게 되는 요즘...',
  //     'tags': '#자존감 #괴로운생각 #메모',
  //   },
  //   {
  //     'date': '2025.05.21',
  //     'type': '음성녹음',
  //     'source': '메모',
  //     'title': '요즘 나를 가장 괴롭히는 생각은?',
  //     'content': '타인의 시선을 너무 신경쓰게 되는 요즘...',
  //     'tags': '#자존감 #괴로운생각 #메모',
  //   },
  //   // ... 추가 메모
  // ];

  final List<String> sources = ['모두', '질문에 대한 답변', '메모'];

  final Map<String, String> sourceTypeMap = {
    '모두': 'all',
    '질문에 대한 답변': 'answer',
    '메모': 'memo',
  };

  @override
  Widget build(BuildContext context) {
    // 필터링된 메모 리스트를 API에서 받아옴
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('사고 기반 히스토리'),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 오늘의 메모 조회 및 표시
            FutureBuilder<Map<String, dynamic>?>(
              future: ApiService.fetchTodayMemo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final todayMemo = snapshot.data;
                if (todayMemo == null || todayMemo['id'] == null) {
                  // 기존 안내문
                  return Center(
                    child: Text(
                      '오늘은 메모를 아직 안했네요\n메모를 시작해볼까요?',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.brown[700],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  // 오늘의 메모가 있을 때 MemoCard로 표시
                  return MemoCard(
                    memo: {
                      'date': todayMemo['createdAt']
                          ?.substring(0, 10)
                          ?.replaceAll('-', '.'),
                      'type': todayMemo['type'] ?? '메모',
                      'source': '메모',
                      'title': todayMemo['title'] ?? '',
                      'content': todayMemo['content'] ?? '',
                      'tags':
                          (todayMemo['tags'] as List?)
                              ?.map((e) => '#$e')
                              .join(' ') ??
                          '',
                    },
                  );
                }
              },
            ),
            SizedBox(height: 24),
            // 드롭다운 + 검색
            Row(
              children: [
                DropdownButton<String>(
                  value: selectedSource,
                  items:
                      sources
                          .map(
                            (source) => DropdownMenuItem(
                              value: source,
                              child: Text(source),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSource = value!;
                    });
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryViewSearch(),
                      ),
                    );
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 메모 리스트 (API 기반)
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: ApiService.fetchHistoryList(
                  type: sourceTypeMap[selectedSource] ?? 'all',
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final memos = snapshot.data ?? [];
                  if (memos.isEmpty) {
                    return Center(child: Text('메모가 없습니다.'));
                  }
                  return ListView.builder(
                    itemCount: memos.length,
                    itemBuilder: (context, idx) {
                      final memo = memos[idx];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => MemoDetailView(
                                    memo: {
                                      'date': memo['createdAt']
                                          ?.substring(0, 10)
                                          ?.replaceAll('-', '.'),
                                      'type': memo['type'] ?? '',
                                      'source':
                                          memo['type'] == 'answer'
                                              ? '질문에 대한 답변'
                                              : '메모',
                                      'title': memo['title'] ?? '',
                                      'content': memo['content'] ?? '',
                                      'tags':
                                          (memo['tags'] as List?)
                                              ?.map((e) => '#$e')
                                              .join(' ') ??
                                          '',
                                    },
                                  ),
                            ),
                          );
                        },
                        child: MemoCard(
                          memo: {
                            'date': memo['createdAt']
                                ?.substring(0, 10)
                                ?.replaceAll('-', '.'),
                            'type': memo['type'] ?? '',
                            'source':
                                memo['type'] == 'answer' ? '질문에 대한 답변' : '메모',
                            'title': memo['title'] ?? '',
                            'content': memo['content'] ?? '',
                            'tags':
                                (memo['tags'] as List?)
                                    ?.map((e) => '#$e')
                                    .join(' ') ??
                                '',
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(currentIndex: 1),
    );
  }
}

// 공통 BottomNavigationBar 위젯 (사용 X)
// class CommonBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;

//   const CommonBottomNavigationBar({required this.currentIndex, Key? key})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 90,
//       child: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.forest_rounded),
//             label: "home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.description_outlined),
//             label: "idea block",
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: "community"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "user"),
//         ],
//         backgroundColor: backgroundColor,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: pointColorStrong,
//         unselectedItemColor: Colors.grey[500],
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         currentIndex: currentIndex,
//       ),
//     );
//   }
// }

// 통합된 메모 카드 위젯
class MemoCard extends StatelessWidget {
  final Map<String, String> memo;
  const MemoCard({required this.memo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memo['date'] ?? '',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  memo['title'] ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  memo['content'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  memo['tags'] ?? '',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(memo['type'] ?? '', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

// 상세화면 위젯 추가
class MemoDetailView extends StatelessWidget {
  final Map<String, String> memo;
  const MemoDetailView({required this.memo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (memo['type'] == '오늘의 질문') {
      return TodayQuestionDetailView(memo: memo);
    } else {
      return MemoDetailCardView(memo: memo);
    }
  }
}

// 메모 내용 카드 위젯
class MemoContentCard extends StatelessWidget {
  final Map<String, String> memo;
  final double? width;

  const MemoContentCard({required this.memo, this.width, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey[400]!, width: 1.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  memo['date'] ?? '',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
                const SizedBox(width: 8),
                ...buildTagChips(memo['tags']),
              ],
            ),
            const SizedBox(height: 8),
            Text(memo['content'] ?? '', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 130),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/edit.png', width: 28, height: 28),
                Image.asset('assets/images/mic.png', width: 28, height: 28),
                Image.asset('assets/images/gallery.png', width: 28, height: 28),
                Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    color: activatedNextbuttonColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      '확인',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'NanumSquareRound',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 연관 메모 추천 카드 위젯
class RelatedMemoCard extends StatelessWidget {
  final Map<String, String> memo;

  const RelatedMemoCard({required this.memo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 246,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey[400]!, width: 1.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              memo['date'] ?? '',
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              memo['title'] ?? '',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              memo['content'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(children: buildTagChips(memo['tags'])),
          ],
        ),
      ),
    );
  }
}

// 연관 메모 섹션 위젯
class RelatedMemosSection extends StatelessWidget {
  final Map<String, String> memo;

  const RelatedMemosSection({required this.memo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '연관된 메모 추천',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        RelatedMemoCard(memo: memo),
        const SizedBox(height: 32),
      ],
    );
  }
}

class TodayQuestionDetailView extends StatelessWidget {
  final Map<String, String> memo;
  const TodayQuestionDetailView({required this.memo, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '오늘의 질문 & 답변',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                memo['title'] ?? '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              MemoContentCard(memo: memo),
              const SizedBox(height: 32),
              RelatedMemosSection(memo: memo),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(currentIndex: 1),
    );
  }
}

class MemoDetailCardView extends StatelessWidget {
  final Map<String, String> memo;
  const MemoDetailCardView({required this.memo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '메모',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                memo['title'] ?? '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              MemoContentCard(memo: memo),
              const SizedBox(height: 32),
              RelatedMemosSection(memo: memo),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(currentIndex: 1),
    );
  }
}

// 태그 칩 빌더 함수 (공용)
List<Widget> buildTagChips(String? tags) {
  if (tags == null) return [];
  return tags
      .split(' ')
      .map(
        (tag) => Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Chip(
            label: Text(tag),
            backgroundColor: Color(0xFFF0EBCE),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            labelStyle: TextStyle(fontSize: 10, color: textColorFirst),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ),
      )
      .toList();
}
