import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';

class HistoryView extends StatefulWidget {
  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String selectedSource = '모두';

  // 임시 메모 데이터
  final List<Map<String, String>> memos = [
    {
      'date': '2025.05.20',
      'type': '오늘의 질문',
      'source': '질문에 대한 답변',
      'title': '요즘 나를 가장 괴롭히는 생각은?',
      'content': '타인의 시선을 너무 신경쓰게 되는 요즘...',
      'tags': '#자존감 #괴로운 생각 #메모',
    },
    {
      'date': '2025.05.20',
      'type': '음성녹음',
      'source': '메모',
      'title': '요즘 나를 가장 괴롭히는 생각은?',
      'content': '타인의 시선을 너무 신경쓰게 되는 요즘...',
      'tags': '#자존감 #괴로운 생각 #메모',
    },
    // ... 추가 메모
  ];

  final List<String> sources = ['모두', '질문에 대한 답변', '메모'];

  @override
  Widget build(BuildContext context) {
    // 필터링된 메모 리스트
    final filteredMemos =
        selectedSource == '모두'
            ? memos
            : memos.where((m) => m['source'] == selectedSource).toList();

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
            // 상단 중앙 안내문
            Center(
              child: Text(
                '오늘은 메모를 아직 안했네요\n메모를 시작해볼까요?',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.brown[700],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
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
                Icon(Icons.search),
              ],
            ),
            const SizedBox(height: 16),
            // 메모 리스트
            Expanded(
              child:
                  filteredMemos.isEmpty
                      ? Center(child: Text('메모가 없습니다.'))
                      : ListView.builder(
                        itemCount: filteredMemos.length,
                        itemBuilder: (context, idx) {
                          final memo = filteredMemos[idx];
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        memo['date'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        memo['title'] ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 오른쪽 상단 메모 유형
                                Positioned(
                                  right: 12,
                                  top: 12,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      memo['type'] ?? '',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      // 하단 네비게이션 등 추가 가능
    );
  }
}
