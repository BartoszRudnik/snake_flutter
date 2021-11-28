import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TopLeaderBoard extends StatelessWidget {
  final int index;
  final String username;

  const TopLeaderBoard({
    Key? key,
    required this.index,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: index == 1 ? 125 : 60,
          width: index == 1 ? 125 : 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green[600]!.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: index == 1
                ? FaIcon(
                    FontAwesomeIcons.trophy,
                    color: Colors.amber[800],
                    size: 42,
                  )
                : Text(
                    index.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white60,
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            username,
            style: TextStyle(
              fontSize: index == 1 ? 32 : 24,
              fontWeight: FontWeight.w500,
              color: index == 1 ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
