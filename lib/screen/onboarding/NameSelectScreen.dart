import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/home_screen.dart';
import 'package:idea_soop/screen/onboarding/StartView.dart';

class NicknameSelectScreen extends StatefulWidget {
  const NicknameSelectScreen({super.key});

  @override
  State<NicknameSelectScreen> createState() => _NicknameSelectScreenState();
}

class _NicknameSelectScreenState extends State<NicknameSelectScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;

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
                  onPressed:
                      _isValid
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => StartView(
                                      nickname: _controller.text.trim(),
                                    ),
                              ),
                            );
                          }
                          : null,
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
                  child: const Text(
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
