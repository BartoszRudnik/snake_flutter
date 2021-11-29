import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_flutter/utils/game_over_dialog.dart';
import 'package:snake_flutter/widget/control_panel.dart';
import 'package:snake_flutter/utils/direction_type.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:snake_flutter/provider/scoreboard_provider.dart';
import 'package:snake_flutter/provider/settings_provider.dart';
import 'package:snake_flutter/widget/game_screen_border.dart';
import 'package:snake_flutter/widget/game_screen_score.dart';
import '../utils/direction.dart';
import '../widget/piece.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wakelock/wakelock.dart';

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

  Piece? foodPiece;
  Offset? foodPosition;

  int? lowerBoundX, upperBoundX, lowerBoundY, upperBoundY;

  Timer? timer;
  double speed = 0.8;
  double startingSpeed = 0.8;

  int score = 0;

  AssetsAudioPlayer? _assetsAudioPlayer;
  AssetsAudioPlayer? _loseAudioPlayer;
  late String username;
  late String mode;
  late Uint8List image;

  @override
  void dispose() {
    super.dispose();

    Wakelock.disable();
  }

  @override
  void initState() {
    super.initState();

    Wakelock.enable();
    playGameMusic();
    restart();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    username = args['username']! as String;
    mode = args['mode'] as String;
    image = args['image'] as Uint8List;

    if (mode == 'hard') {
      startingSpeed = 1.5;
    }
  }

  void saveUserScore() {
    Provider.of<ScoreboardProvider>(context, listen: false).addUser(username, score, mode, image);
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
    final isVibrate = Provider.of<SettingsProvider>(context, listen: false).settings.isVibration;

    if (isVibrate) {
      HapticFeedback.heavyImpact();
    }
  }

  void vibrate() {
    final isVibrate = Provider.of<SettingsProvider>(context, listen: false).settings.isVibration;

    if (isVibrate) {
      Vibrate.vibrate();
    }
  }

  void playLoseMusic() async {
    final isMusic = Provider.of<SettingsProvider>(context, listen: false).settings.isMusic;

    if (_assetsAudioPlayer != null) {
      await _assetsAudioPlayer!.stop();
    }

    if (isMusic) {
      _loseAudioPlayer = AssetsAudioPlayer.withId("0");
      await _loseAudioPlayer!.open(
        Audio("assets/audios/lose.mp3"),
      );
      await _loseAudioPlayer!.play();
    }
  }

  void playGameMusic() async {
    final isMusic = Provider.of<SettingsProvider>(context, listen: false).settings.isMusic;

    if (_loseAudioPlayer != null) {
      await _loseAudioPlayer!.stop();
    }

    if (isMusic) {
      _assetsAudioPlayer = null;
      _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
      await _assetsAudioPlayer!.open(
        Audio("assets/audios/back.mp3"),
      );
      await _assetsAudioPlayer!.play();
    }
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
        () => GameOverDialog.showGameOverDialog(context, score, restart, _loseAudioPlayer),
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
        () => GameOverDialog.showGameOverDialog(context, score, restart, _loseAudioPlayer),
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

    foodPiece = Piece(
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

    timer = Timer.periodic(
      Duration(milliseconds: 200 ~/ speed),
      (timer) {
        setState(() {});
      },
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    lowerBoundX = step;
    lowerBoundY = step;
    upperBoundX = roundToNearestTens(screenWidth.toInt() - step);
    upperBoundY = roundToNearestTens(screenHeight.toInt() - step);

    listenToGyroscopeStream();

    return Scaffold(
      body: Container(
        color: Colors.green[600],
        child: Stack(
          children: [
            GameScreenBorder(
              lowerBoundX: lowerBoundX,
              lowerBoundY: lowerBoundY,
              upperBoundX: upperBoundX,
              upperBoundY: upperBoundY,
              step: step,
            ),
            Stack(
              children: getPieces(),
            ),
            ControlPanel(previousDirection: direction),
            foodPiece!,
            GameScreenScore(score: score),
          ],
        ),
      ),
    );
  }
}
