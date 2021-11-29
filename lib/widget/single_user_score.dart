import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SingleUserScore extends StatelessWidget {
  final int index;
  final int score;
  final Uint8List? image;
  final String username;

  const SingleUserScore({
    Key? key,
    required this.index,
    required this.image,
    required this.username,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: index == 0
          ? const FaIcon(
              FontAwesomeIcons.trophy,
              color: Colors.white,
            )
          : Text(
              (index + 1).toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
      title: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: MemoryImage(image!),
                      radius: 30,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: index == 0 ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Text(
                    score.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: index == 0 ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.star_rate,
                    color: index == 0 ? Colors.white : Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
