import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snake_flutter/provider/scoreboard_provider.dart';
import 'package:snake_flutter/provider/settings_provider.dart';
import 'package:snake_flutter/config/routes.dart';
import 'package:snake_flutter/utils/start_game_dialog.dart';
import 'package:snake_flutter/widget/button/entry_screen_button_design.dart';
import 'package:snake_flutter/widget/entry_screen_title.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  late Future _future;

  Future<void> loadPreviousData() async {
    await Future.wait(
      [
        Provider.of<ScoreboardProvider>(context, listen: false).loadData(),
        Provider.of<SettingsProvider>(context, listen: false).loadSettings(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
    );

    _future = loadPreviousData();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context).settings;

    return Scaffold(
      backgroundColor: Colors.green[600],
      body: FutureBuilder(
        future: _future,
        builder: (ctx, loadingResult) => loadingResult.connectionState == ConnectionState.waiting
            ? const CircularProgressIndicator()
            : SafeArea(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const EntryScreenTitle(),
                        TextButton(
                          onPressed: () async {
                            final args = await StartGameDialog.showStartDialog(context);

                            if (args.isNotEmpty) {
                              Navigator.of(context).pushNamed(
                                Routes.gamePageRoute,
                                arguments: {
                                  "username": args[0],
                                  "mode": args[1],
                                  "image": args[2],
                                },
                              );
                            }
                          },
                          child: const EntryScreenButtonDesign(
                            iconData: Icons.play_arrow,
                            buttonTitle: "Play",
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(Routes.scoreboardRoute);
                          },
                          child: const EntryScreenButtonDesign(
                            iconData: Icons.table_chart,
                            buttonTitle: "Scoreboard",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Provider.of<SettingsProvider>(context, listen: false).changeMusicStatus();
                                },
                                icon: Icon(
                                  settings.isMusic ? Icons.headset_outlined : Icons.headset_off_outlined,
                                  color: Colors.amber[700],
                                  size: 42,
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                onPressed: () {
                                  Provider.of<SettingsProvider>(context, listen: false).changeVibrationStatus();
                                },
                                icon: Icon(
                                  settings.isVibration ? Icons.vibration_outlined : Icons.mobile_off_outlined,
                                  color: Colors.amber[700],
                                  size: 42,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
