import 'package:flutter/material.dart';
import 'package:snake_flutter/screen/entry_screen.dart';
import 'package:snake_flutter/provider/scoreboard_provider.dart';
import 'package:snake_flutter/provider/settings_provider.dart';
import 'package:snake_flutter/config/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ScoreboardProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Snake',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const EntryScreen(),
        routes: Routes.routes,
      ),
    );
  }
}
