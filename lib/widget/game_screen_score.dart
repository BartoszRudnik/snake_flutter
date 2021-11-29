import 'package:flutter/material.dart';

class GameScreenScore extends StatelessWidget {
  final int score;

  const GameScreenScore({
    Key? key,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50.0,
      right: 40.0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: Text(
          "Score: " + score.toString(),
          key: ValueKey(score),
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
