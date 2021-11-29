import 'package:snake_flutter/screen/entry_screen.dart';
import 'package:snake_flutter/screen/game.dart';
import 'package:snake_flutter/screen/scoreboard.dart';

class Routes {
  static String gamePageRoute = "/gamePage";
  static String entryPageRoute = "/entryPage";
  static String scoreboardRoute = "/scoreboard";

  static final routes = {
    gamePageRoute: (ctx) => const GamePage(),
    entryPageRoute: (ctx) => const EntryScreen(),
    scoreboardRoute: (ctx) => const Scoreboard(),
  };
}
