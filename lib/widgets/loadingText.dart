import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoadingText extends StatelessWidget {
  final String text;
  const LoadingText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 20.0,
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          WavyAnimatedText(text),
        ],
        isRepeatingAnimation: true,
      ),
    );
  }
}
