import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/HistoryView.dart';
import 'package:idea_soop/screen/home_screen.dart';

class Memo {
  final String date;
  final String type;
  final String source;
  final String title;
  final String content;
  final List<String> tags;

  Memo({
    required this.date,
    required this.type,
    required this.source,
    required this.title,
    required this.content,
    required this.tags,
  });

  factory Memo.fromMap(Map<String, String> map) {
    return Memo(
      date: map['date'] ?? '',
      type: map['type'] ?? '',
      source: map['source'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      tags: (map['tags'] ?? '')
        .split(' ')
        .where((tag) => tag.trim().isNotEmpty)
        .toList(),
    );
  }
}


class HistoryViewSearch extends StatefulWidget {
  State<HistoryViewSearch> createState() => _HistoryViewSearchState();
}

class _HistoryViewSearchState extends State<HistoryViewSearch> {
  //임시 리스트
  final List<String> tempTags = ['자존감', '괴로운생각', '비교'];
  final List<String> tempKeywords = ['#비교', '불안한 마음'];
  final List<Memo> tempMemos = [
    Memo(
      date: '2025.05.20',
      type: '오늘의 질문',
      source: '질문에 대한 답변',
      title: '요즘 나를 가장 괴롭히는 생각은?',
      content: '타인의 시선을 너무 신경쓰게 되는 요즘...',
      tags: ['자존감', '메모'],
    ),
    Memo(
      date: '2025.05.20',
      type: '음성녹음',
      source: '메모',
      title: '요즘 나를 가장 괴롭히는 생각은?',
      content: '타인의 시선을 너무 신경쓰게 되는 요즘...',
      tags: ['자존감', '괴로운 생각', '메모'],
    ),
    Memo(
      date: '2025.05.20',
      type: '음성녹음',
      source: '메모',
      title: '요즘 나를 가장 괴롭히는 생각은?',
      content: '타인의 시선을 너무 신경쓰게 되는 요즘...',
      tags: ['자존감', '괴로운 생각', '메모'],
    ),
    Memo(
      date: '2025.05.20',
      type: '음성녹음',
      source: '메모',
      title: '요즘 나를 가장 괴롭히는 생각은?',
      content: '타인의 시선을 너무 신경쓰게 되는 요즘...',
      tags: ['자존감', '괴로운 생각', '메모'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            SearchBar(),
            SizedBox(height: 50),
            TagBox(tags: tempTags),
            SizedBox(height: 50),
            KeywordBox(words: tempKeywords),
            SizedBox(height: 50),
            MemoBox(memos: tempMemos,),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(currentIndex: 1),
    );
  }
}

class SearchBar extends StatefulWidget {
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                hintStyle: TextStyle(color: textColorThird),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: backgroundColorStrong,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryView()),
              );
            },
            child: Text("취소", style: TextStyle(fontSize: 18,color: textColorFirst)),
          ),
        ],
      ),
    );
  }
}

class TagBox extends StatelessWidget {
  final List<String> tags;

  TagBox({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "추천 태그",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 15),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8.0,
            runSpacing: 8.0,
            children: tags.map((tag) => _buildTag(tag)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColorStrong, // 배경색
        borderRadius: BorderRadius.circular(25), // 모서리 둥글게
      ),
      child: Text(
        '#$tag',
        style: TextStyle(
          color: textColorSecond, // 텍스트 색상
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class KeywordBox extends StatelessWidget {
  final List<String> words;

  KeywordBox({required this.words});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "최근 검색어",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                words
                    .map(
                      (tag) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: textColorSecond,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class MemoBox extends StatelessWidget {

  final List<Memo> memos;

  MemoBox({required this.memos});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '최근 메모',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 140, // 카드 높이
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: memos.length,
              itemBuilder: (context, index) {
                final memo = memos[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: MemoCardSmall(memo: memo),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}


class MemoCardSmall extends StatelessWidget {
  final Memo memo;

  const MemoCardSmall({super.key, required this.memo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // 가로 크기
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColorFirst),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            memo.date,
            style: TextStyle(fontSize: 12, color: textColorSecond),
          ),
          const SizedBox(height: 4),
          Text(
            memo.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColorFirst),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              memo.content,
              style: TextStyle(fontSize: 14, color: textColorSecond),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8.0,
            runSpacing: 8.0,
            children: memo.tags.map((tag) => _buildTag(tag)).toList(),
          ),
        ],
      ),
    );
  }
  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColorStrong, // 배경색
        borderRadius: BorderRadius.circular(25), // 모서리 둥글게
      ),
      child: Text(
        '#$tag',
        style: TextStyle(
          color: textColorSecond, // 텍스트 색상
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
