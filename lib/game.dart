import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_flutter/control_panel.dart';
import 'package:snake_flutter/direction_type.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/services.dart';
import 'package:snake_flutter/provider/scoreboard_provider.dart';
import 'package:snake_flutter/routes.dart';
import 'direction.dart';
import 'piece.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    Key? key,
  }) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Offset> positions = [];
  int length = 5;
  int step = 20;
  Direction direction = Direction.right;

  Piece? food;
  Offset? foodPosition;

  double? screenWidth;
  double? screenHeight;
  int? lowerBoundX, upperBoundX, lowerBoundY, upperBoundY;

  Timer? timer;
  double speed = 0.8;
  double startingSpeed = 0.8;

  int score = 0;

  AssetsAudioPlayer? _assetsAudioPlayer;
  AssetsAudioPlayer? _loseAudioPlayer;
  late String username;

  @override
  void initState() {
    super.initState();

    playGameMusic();

    restart();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    username = args['username']!;

    if (args['mode']! == 'hard') {
      startingSpeed = 1.5;
    }
  }

  void saveUserScore() {
    Provider.of<ScoreboardProvider>(context, listen: false).addUser(username, score);
  }

  void listenToGyroscopeStream() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (event.x > 1 && event.x > event.y) {
        if (direction != Direction.up && direction != Direction.down) {
          direction = Direction.down;
        }
      } else if (event.x < -1 && event.x < event.y) {
        if (direction != Direction.down && direction != Direction.up) {
          direction = Direction.up;
        }
      } else if (event.y > 1 && event.y > event.x) {
        if (direction != Direction.left && direction != Direction.right) {
          direction = Direction.right;
        }
      } else if (event.y < -1 && event.y < event.x) {
        if (direction != Direction.right && direction != Direction.left) {
          direction = Direction.left;
        }
      }
    });
  }

  void foodCollectionVibration() {
    HapticFeedback.heavyImpact();
  }

  void vibrate() {
    Vibrate.vibrate();
  }

  void playLoseMusic() async {
    if (_assetsAudioPlayer != null) {
      await _assetsAudioPlayer!.stop();
    }

    _loseAudioPlayer = AssetsAudioPlayer.withId("0");
    await _loseAudioPlayer!.open(
      Audio("assets/audios/lose.mp3"),
    );
    await _loseAudioPlayer!.play();
  }

  void playGameMusic() async {
    if (_loseAudioPlayer != null) {
      await _loseAudioPlayer!.stop();
    }
    _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
    await _assetsAudioPlayer!.open(
      Audio("assets/audios/back.mp3"),
    );
    await _assetsAudioPlayer!.play();
  }

  void draw() async {
    if (positions.isEmpty) {
      positions.add(getRandomPositionWithinRange());
    }

    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    for (int i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }

    positions[0] = await getNextPosition(positions[0]);
  }

  Direction getRandomDirection([DirectionType? type]) {
    if (type == DirectionType.horizontal) {
      bool random = Random().nextBool();
      if (random) {
        return Direction.right;
      } else {
        return Direction.left;
      }
    } else if (type == DirectionType.vertical) {
      bool random = Random().nextBool();
      if (random) {
        return Direction.up;
      } else {
        return Direction.down;
      }
    } else {
      int random = Random().nextInt(4);
      return Direction.values[random];
    }
  }

  Offset getRandomPositionWithinRange() {
    int posX = Random().nextInt(upperBoundX!) + lowerBoundX!;
    int posY = Random().nextInt(upperBoundY!) + lowerBoundY!;
    return Offset(roundToNearestTens(posX).toDouble(), roundToNearestTens(posY).toDouble());
  }

  bool detectSnakeCollision(Offset position) {
    if (positions.length > 1) {
      for (int i = 1; i < positions.length - 1; i++) {
        if (positions[i].dx == position.dx && positions[i].dy == position.dy) {
          return true;
        }
      }
    }

    return false;
  }

  bool detectBorderCollision(Offset position) {
    if (position.dx >= upperBoundX! && direction == Direction.right) {
      return true;
    } else if (position.dx <= lowerBoundX! && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperBoundY! && direction == Direction.down) {
      return true;
    } else if (position.dy <= lowerBoundY! && direction == Direction.up) {
      return true;
    } else {
      return false;
    }
  }

  void showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.amber[700],
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black,
              width: 3.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          title: const Center(
            child: Text(
              "Game Over",
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Text(
            "Your game is over but you played well. Your score is " + score.toString() + ".",
            style: const TextStyle(color: Colors.white),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
              onPressed: () async {
                await _assetsAudioPlayer!.stop();

                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(Routes.entryPageRoute);
              },
              child: const Text(
                "Go back to main menu",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                restart();
              },
              child: const Text(
                "Restart",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Offset> getNextPosition(Offset position) async {
    late Offset nextPosition;

    if (detectBorderCollision(position)) {
      saveUserScore();

      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }

      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
        () => showGameOverDialog(),
      );

      playLoseMusic();
      vibrate();

      return position;
    }

    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }

    if (detectSnakeCollision(nextPosition)) {
      saveUserScore();

      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }

      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
        () => showGameOverDialog(),
      );

      playLoseMusic();
      vibrate();

      return position;
    }

    return nextPosition;
  }

  void drawFood() {
    foodPosition ??= getRandomPositionWithinRange();

    if (foodPosition == positions[0]) {
      length++;
      speed = speed + 0.25;
      score = score + 5;
      changeSpeed();
      foodCollectionVibration();

      foodPosition = getRandomPositionWithinRange();
    }

    food = Piece(
      posX: foodPosition!.dx.toInt(),
      posY: foodPosition!.dy.toInt(),
      size: step,
      isAnimated: true,
      color: Colors.black,
    );
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();
    drawFood();

    for (int i = 0; i < length; ++i) {
      if (i < positions.length) {
        pieces.add(
          Piece(
            posX: positions[i].dx.toInt(),
            posY: positions[i].dy.toInt(),
            size: step,
            color: Colors.red,
          ),
        );
      }
    }

    return pieces;
  }

  Widget getControls() {
    return ControlPanel(
      previousDirection: direction,
    );
  }

  int roundToNearestTens(int num) {
    int divisor = step;
    int output = (num ~/ divisor) * divisor;
    if (output == 0) {
      output += step;
    }
    return output;
  }

  void changeSpeed() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }

    timer = Timer.periodic(Duration(milliseconds: 200 ~/ speed), (timer) {
      setState(() {});
    });
  }

  Widget getScore() {
    return Positioned(
      top: 50.0,
      right: 40.0,
      child: Text(
        "Score: " + score.toString(),
        style: const TextStyle(fontSize: 24.0),
      ),
    );
  }

  void restart() {
    score = 0;
    length = 5;
    positions = [];
    direction = getRandomDirection();
    speed = startingSpeed;

    playGameMusic();
    changeSpeed();
  }

  Widget getPlayAreaBorder() {
    return Positioned(
      top: lowerBoundY!.toDouble(),
      left: lowerBoundX!.toDouble(),
      child: Container(
        width: (upperBoundX! - lowerBoundX! + step).toDouble(),
        height: (upperBoundY! - lowerBoundY! + step).toDouble(),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    lowerBoundX = step;
    lowerBoundY = step;
    upperBoundX = roundToNearestTens(screenWidth!.toInt() - step);
    upperBoundY = roundToNearestTens(screenHeight!.toInt() - step);

    listenToGyroscopeStream();

    return Scaffold(
      body: Container(
        color: Colors.green[600],
        child: Stack(
          children: [
            getPlayAreaBorder(),
            Stack(
              children: getPieces(),
            ),
            getControls(),
            food!,
            getScore(),
          ],
        ),
      ),
    );
  }
}
