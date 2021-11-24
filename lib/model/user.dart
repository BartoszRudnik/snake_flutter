class User {
  String username;
  int score;

  User({
    required this.username,
    required this.score,
  });

  static User fromJson(Map<String, Object> json) => User(
        username: json['username'] as String,
        score: json['score'] as int,
      );

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "score": score,
    };
  }
}
