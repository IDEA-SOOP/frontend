import 'package:flutter/material.dart';
import 'package:idea_soop/const/Colors.dart';
import 'package:idea_soop/screen/home_screen.dart';

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
          children: [
            const SizedBox(height: 100),
            Top(),
            const SizedBox(height: 40),
            NicknameInput(controller: _controller, onChanged: _onChanged),
            const SizedBox(height: 40),
            NextButton(isValid: _isValid),
          ],
        ),
      ),
    );
  }

  void _onChanged(String value) {
    setState(() {
      _isValid = value.trim().length >= 2 && value.trim().length <= 10;
    });
  }
}

class Top extends StatelessWidget {
  const Top({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '“당신을 어떻게 불러드릴까요?”',
      style: TextStyle(
        fontSize: 20,
        color: Color(0xFF444444),
        fontWeight: FontWeight.w500,
        fontFamily: 'NanumSquareRound',
      ),
      textAlign: TextAlign.center,
    );
  }
}

class NicknameInput extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  const NicknameInput({
    super.key,
    required this.onChanged,
    required this.controller,
  });

  @override
  State<NicknameInput> createState() => _NicknameInputState();
}

class _NicknameInputState extends State<NicknameInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        maxLength: 10,
        decoration: const InputDecoration(
          hintText: '2~10자 이내로 입력해 주세요',
          counterText: '',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBDBDBD)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBDBDBD)),
          ),
        ),
        style: const TextStyle(fontSize: 18, fontFamily: 'NanumSquareRound'),
      ),
    );
  }
}

class NextButton extends StatefulWidget {
  final bool isValid;
  const NextButton({super.key, required this.isValid});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed:
              widget.isValid
                  ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  }
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: pointColorStrong,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            '시작하기',
            style: TextStyle(fontSize: 18, fontFamily: 'NanumSquareRound'),
          ),
        ),
      ),
    );
  }
}
