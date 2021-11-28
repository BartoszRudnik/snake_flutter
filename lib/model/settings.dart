class Settings {
  bool isMusic;
  bool isVibration;

  Settings({
    required this.isMusic,
    required this.isVibration,
  });

  static Settings fromJson(Map<String, Object> json) => Settings(
        isMusic: json['isMusic'] == 1 ? true : false,
        isVibration: json['isVibration'] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() {
    return {
      "isMusic": isMusic ? 1 : 0,
      "isVibration": isVibration ? 1 : 0,
    };
  }
}
