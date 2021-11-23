import 'package:flutter/material.dart';

class ActiveControlButton extends StatelessWidget {
  final Function onPressed;
  final Icon icon;

  const ActiveControlButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: SizedBox(
        width: 80.0,
        height: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            elevation: 0.0,
            child: icon,
            onPressed: () => onPressed(),
          ),
        ),
      ),
    );
  }
}
