import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snake_flutter/provider/scoreboard_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snake_flutter/widget/top_leaderboard.dart';
import 'package:screenshot/screenshot.dart';

class Scoreboard extends StatelessWidget {
  Scoreboard({Key? key}) : super(key: key);

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<ScoreboardProvider>(context).sortedUsers;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        title: const Text(
          "Scoreboard",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final fileBytes = await screenshotController.capture();
              final directory = await getApplicationDocumentsDirectory();
              final image = File('${directory.path}/liveResultsAppScreenshot.png');

              image.writeAsBytesSync(fileBytes!);

              await Share.shareFiles([image.path]);
            },
            icon: const Icon(Icons.share_outlined),
          )
        ],
      ),
      backgroundColor: Colors.green[600],
      body: Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.green[800],
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TopLeaderBoard(
                              index: 2,
                              username: users[1].username,
                            ),
                            TopLeaderBoard(
                              index: 1,
                              username: users[0].username,
                            ),
                            TopLeaderBoard(
                              index: 3,
                              username: users[2].username,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (ctx, index) => Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16,
                        bottom: 4,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: index == 0 ? Colors.amber[800] : Colors.green[600],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 25,
                        ),
                        child: ListTile(
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
                              children: [
                                Expanded(
                                  child: Text(
                                    users[index].username,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: index == 0 ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      users[index].score.toString(),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
