import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_flutter/provider/scoreboard_provider.dart';
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
    await Provider.of<ScoreboardProvider>(context, listen: false).loadData();
  }

  @override
  void initState() {
    super.initState();

    _future = loadPreviousData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: FutureBuilder(
        future: _future,
        builder: (ctx, loadingResult) => loadingResult.connectionState == ConnectionState.waiting
            ? const CircularProgressIndicator()
            : SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Snake !",
                      style: GoogleFonts.pacifico(
                        textStyle: TextStyle(
                          color: Colors.amber[800],
                          fontSize: 64,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                              child: Text(
                                'Play',
                                style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                    color: Colors.amber[700],
                                    fontSize: 42,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(Routes.scoreboardRoute);
                              },
                              child: Text(
                                'Scoreboard',
                                style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                    color: Colors.amber[700],
                                    fontSize: 42,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}