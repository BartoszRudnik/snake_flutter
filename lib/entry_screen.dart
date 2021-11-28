import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_flutter/provider/scoreboard_provider.dart';
import 'package:snake_flutter/provider/settings_provider.dart';
import 'package:snake_flutter/routes.dart';
import 'package:snake_flutter/utils/start_game_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Image.asset(
                                "assets/images/snake_logo2.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Snake !",
                            style: GoogleFonts.pacifico(
                              textStyle: TextStyle(
                                color: Colors.amber[800],
                                fontSize: 64,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final args = await StartGameDialog.showStartDialog(context);

                            if (args.isNotEmpty) {
                              Navigator.of(context).pushNamed(
                                Routes.gamePageRoute,
                                arguments: {
                                  "username": args[0],
                                  "mode": args[1],
                                },
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Play',
                                style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                    color: Colors.amber[700],
                                    fontSize: 42,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.play_arrow,
                                color: Colors.amber[700],
                                size: 42,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(Routes.scoreboardRoute);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Scoreboard',
                                style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                    color: Colors.amber[700],
                                    fontSize: 42,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.table_chart,
                                color: Colors.amber[700],
                                size: 42,
                              ),
                            ],
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
