import 'package:flutter/material.dart';

class ChangeScoreboardButton extends StatelessWidget {
  final Animation<double> hideFloatingButton;
  final Function setActiveMode;

  ChangeScoreboardButton({
    Key? key,
    required this.hideFloatingButton,
    required this.setActiveMode,
  }) : super(key: key);

  final isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: hideFloatingButton,
      alignment: Alignment.bottomCenter,
      child: FloatingActionButton(
        backgroundColor: Colors.amber[800],
        child: const Icon(
          Icons.swap_horiz_outlined,
          color: Colors.white,
          size: 32,
        ),
        onPressed: () => setActiveMode(),
      ),
    );
  }
}
