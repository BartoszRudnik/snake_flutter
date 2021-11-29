import 'package:flutter/material.dart';

class GameScreenBorder extends StatelessWidget {
  final int? lowerBoundY;
  final int? lowerBoundX;
  final int? upperBoundX;
  final int? upperBoundY;
  final int step;

  const GameScreenBorder({
    Key? key,
    required this.lowerBoundX,
    required this.lowerBoundY,
    required this.upperBoundX,
    required this.upperBoundY,
    required this.step,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: lowerBoundY!.toDouble(),
      left: lowerBoundX!.toDouble(),
      child: Container(
        width: (upperBoundX! - lowerBoundX! + step).toDouble(),
        height: (upperBoundY! - lowerBoundY! + step).toDouble(),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
