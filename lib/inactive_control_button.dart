import 'package:flutter/material.dart';

class InActiveControlButton extends StatelessWidget {
  final Icon icon;

  const InActiveControlButton({
    Key? key,
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
            backgroundColor: Colors.white,
            elevation: 0.0,
            child: icon,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
