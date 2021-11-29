import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EntryScreenButtonDesign extends StatelessWidget {
  final IconData iconData;
  final String buttonTitle;

  const EntryScreenButtonDesign({
    Key? key,
    required this.iconData,
    required this.buttonTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          buttonTitle,
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(
              color: Colors.amber[700],
              fontSize: 42,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Icon(
          iconData,
          color: Colors.amber[700],
          size: 42,
        ),
      ],
    );
  }
}
