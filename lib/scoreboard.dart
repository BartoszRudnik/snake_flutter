import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_flutter/provider/scoreboard_provider.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<ScoreboardProvider>(context).sortedUsers;

    return Scaffold(
      backgroundColor: Colors.green[600],
      body: SafeArea(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (ctx, index) => Text(
            users[index].username + " " + users[index].score.toString(),
          ),
        ),
      ),
    );
  }
}
