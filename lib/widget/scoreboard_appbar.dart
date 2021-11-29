import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ScoreBoardAppBar extends StatelessWidget with PreferredSizeWidget {
  final String actualMode;
  final ScreenshotController screenshotController;

  const ScoreBoardAppBar({
    Key? key,
    required this.actualMode,
    required this.screenshotController,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green[800],
      elevation: 0,
      titleSpacing: 0,
      centerTitle: true,
      title: Text(
        "Scoreboard - " + actualMode,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 24,
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
    );
  }
}
