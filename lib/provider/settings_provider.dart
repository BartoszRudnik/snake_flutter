import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_flutter/model/settings.dart';

class SettingsProvider with ChangeNotifier {
  Settings settings = Settings(
    isMusic: true,
    isVibration: true,
  );

  void changeMusicStatus() {
    settings.isMusic = !settings.isMusic;
    saveSettings();

    notifyListeners();
  }

  void changeVibrationStatus() {
    settings.isVibration = !settings.isVibration;
    saveSettings();

    notifyListeners();
  }

  void saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsData = json.encode(settings);

    await prefs.setString("userSettings", settingsData);
  }

  Future<bool> loadSettings() async {
    final getPreferences = await SharedPreferences.getInstance();

    if (!getPreferences.containsKey("userSettings")) {
      return false;
    }

    final extractedSettings = json.decode(getPreferences.getString("userSettings")!);

    settings = Settings(
      isMusic: extractedSettings['isMusic'] == 1,
      isVibration: extractedSettings['isVibration'] == 1,
    );

    notifyListeners();

    return true;
  }
}
