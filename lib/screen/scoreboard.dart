import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:snake_flutter/model/user.dart';
import 'package:snake_flutter/provider/scoreboard_provider.dart';
import 'package:snake_flutter/widget/button/change_scoreboard_button.dart';
import 'package:snake_flutter/widget/scoreboard_appbar.dart';
import 'package:snake_flutter/widget/single_user_score.dart';
import 'package:snake_flutter/widget/top_leaderboard.dart';
import 'package:screenshot/screenshot.dart';

class Scoreboard extends StatefulWidget {
  const Scoreboard({Key? key}) : super(key: key);

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> with TickerProviderStateMixin<Scoreboard> {
  ScreenshotController screenshotController = ScreenshotController();
  late AnimationController hideFloatingButton;

  bool isNormal = true;

  void changeActualMode() {
    setState(() {
      isNormal = !isNormal;
    });
  }

  @override
  void initState() {
    super.initState();

    hideFloatingButton = AnimationController(vsync: this, duration: kThemeAnimationDuration);
    hideFloatingButton.forward();
  }

  bool handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              hideFloatingButton.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              hideFloatingButton.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<User> users = Provider.of<ScoreboardProvider>(context).sortedUsers;

    if (isNormal) {
      users = users.where((element) => element.mode == 'normal').toList();
    } else {
      users = users.where((element) => element.mode == 'hard').toList();
    }

    String actualMode = isNormal ? "Normal" : "Hard";

    return NotificationListener(
      onNotification: handleScrollNotification,
      child: Scaffold(
        floatingActionButton: ChangeScoreboardButton(
          setActiveMode: changeActualMode,
          hideFloatingButton: hideFloatingButton,
        ),
        appBar: ScoreBoardAppBar(
          actualMode: actualMode,
          screenshotController: screenshotController,
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
                              Expanded(
                                flex: 1,
                                child: TopLeaderBoard(
                                  index: 2,
                                  username: users.length >= 2 ? users[1].username : '',
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: TopLeaderBoard(
                                  index: 1,
                                  username: users.isNotEmpty ? users[0].username : '',
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TopLeaderBoard(
                                  index: 3,
                                  username: users.length >= 3 ? users[2].username : '',
                                ),
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
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16,
                          ),
                          child: SingleUserScore(
                            index: index,
                            image: users[index].image,
                            username: users[index].username,
                            score: users[index].score,
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
      ),
    );
  }
}
