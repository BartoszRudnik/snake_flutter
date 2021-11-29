import 'package:snake_flutter/entry_screen.dart';
import 'package:snake_flutter/game.dart';
import 'package:snake_flutter/scoreboard.dart';

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
