import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EntryScreenTitle extends StatelessWidget {
  const EntryScreenTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(
                "assets/images/snake_logo2.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Flexible(
          child: Text(
            "Snake !",
            style: GoogleFonts.pacifico(
              textStyle: TextStyle(
                color: Colors.amber[800],
                fontSize: 64,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
