import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/home_screen.dart';

class CharacterScreen extends StatefulWidget {
  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  String selectedType = 'all'; // 'character', 'decoration', 'background'
  bool showOnlyMyItems = true;

  final List<Item> allItems = [
    Item(type: 'character', image: 'assets/images/bear.png', isMine: true),
    Item(type: 'character', image: 'assets/images/fox.png', isMine: false),
    Item(type: 'background', image: 'assets/images/bg.png', isMine: true),
    // 추가 아이템들...
  ];

  List<Item> get filteredItems {
    return allItems.where((item) {
      final matchType = selectedType == 'all' || item.type == selectedType;
      final matchMy = !showOnlyMyItems || item.isMine;
      return matchType && matchMy;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          CharacterScreenAppBar(),
          // 상단 캐릭터 미리보기
          Row(
            children: [
              SizedBox(width: (MediaQuery.of(context).size.width - 220) / 2),
              Container(
                height: 280,
                width: 220,
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/bear.png', height: 200),
              ),
              // 저장 버튼
              Container(
                width: (MediaQuery.of(context).size.width - 220) / 2,
                height: 280,
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.fromLTRB(0, 0, 18, 15),
                child: ElevatedButton(onPressed: () {}, child: Text('저장')),
              ),
            ],
          ),

          // 라벨 필터
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilterButton(
                label: 'MY',
                selected: showOnlyMyItems,
                onTap: () {
                  setState(() => showOnlyMyItems = !showOnlyMyItems);
                },
              ),
              FilterButton(
                label: '캐릭터',
                selected: selectedType == 'character',
                onTap: () {
                  setState(() => selectedType = 'character');
                },
              ),
              FilterButton(
                label: '장식',
                selected: selectedType == 'decoration',
                onTap: () {
                  setState(() => selectedType = 'decoration');
                },
              ),
              FilterButton(
                label: '배경',
                selected: selectedType == 'background',
                onTap: () {
                  setState(() => selectedType = 'background');
                },
              ),
            ],
          ),

          // 아이템 리스트
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, index) {
                final item = filteredItems[index];
                return Image.asset(item.image);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNav(currentIndex: 2),
    );
  }
}

class Item {
  final String type;
  final String image;
  final bool isMine;

  Item({required this.type, required this.image, required this.isMine});
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}

class CharacterScreenAppBar extends StatelessWidget {
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
                "내 캐릭터",
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
