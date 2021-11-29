import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class GameOverDialog {
  static void showGameOverDialog(BuildContext context, int score, Function restart, AssetsAudioPlayer? assetsAudioPlayer) {
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
            "Your score is " + score.toString() + ".",
            style: const TextStyle(color: Colors.white),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            TextButton(
              onPressed: () async {
                if (assetsAudioPlayer != null) {
                  await assetsAudioPlayer.stop();
                }

                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
}
