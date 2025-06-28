import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/home_screen.dart';
import 'package:idea_soop/screen/onboarding/StartView.dart';
import 'package:idea_soop/services/api_service.dart';

class NicknameSelectScreen extends StatefulWidget {
  final int? userId;
  final String? jwt;
  final List<int> selectedCategoryIds;
  final int selectedCharacterId;

  const NicknameSelectScreen({
    super.key,
    this.userId,
    this.jwt,
    this.selectedCategoryIds = const [],
    this.selectedCharacterId = 1,
  });

  @override
  State<NicknameSelectScreen> createState() => _NicknameSelectScreenState();
}

class _NicknameSelectScreenState extends State<NicknameSelectScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;
  bool _isLoading = false;

  Future<void> _updateUserInfo() async {
    if (!_isValid || widget.userId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final animalId = widget.selectedCharacterId;
      final categoryIds =
          widget.selectedCategoryIds.isNotEmpty
              ? widget.selectedCategoryIds
              : [1, 2, 3, 4, 5, 6];
      final nickname = _controller.text.trim();

      print('사용자 정보 업데이트 요청:');
      print('- userId: ${widget.userId}');
      print('- animalId: $animalId');
      print('- categoryIds: $categoryIds (null 체크 완료)');
      print('- nickname: $nickname');

      await ApiService.updateExtraInfo(
        userId: widget.userId!,
        animalId: animalId,
        categoryIds: categoryIds,
        nickname: nickname,
        jwt: widget.jwt,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StartView(nickname: nickname)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('사용자 정보 업데이트 실패: $e'),
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                '닉네임을 알려주세요',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColorFirst,
                  fontFamily: 'NanumSquareRound',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                '닉네임은 이후에도 변경할 수 있어요',
                style: const TextStyle(
                  fontSize: 16,
                  color: textColorThird,
                  fontFamily: 'NanumSquareRound',
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _isValid =
                        value.trim().length >= 2 && value.trim().length <= 10;
                  });
                },
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: '2~10자 이내로 입력해주세요',
                  hintStyle: TextStyle(
                    color: textColorThird,
                    fontSize: 16,
                    fontFamily: 'NanumSquareRound',
                  ),
                  counterText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: unactivatedNextbuttonColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: activatedNextbuttonColor),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'NanumSquareRound',
                ),
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: _isValid && !_isLoading ? _updateUserInfo : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((
                      Set<MaterialState> states,
                    ) {
                      if (states.contains(MaterialState.disabled)) {
                        return unactivatedNextbuttonColor;
                      }
                      return activatedNextbuttonColor;
                    }),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            '완료',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'NanumSquareRound',
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
