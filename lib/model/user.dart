import 'dart:typed_data';

class User {
  String username;
  String mode;
  int score;
  Uint8List? image;

  User({
    required this.username,
    required this.score,
    required this.image,
    required this.mode,
  });

  static User fromJson(Map<String, Object> json) => User(
        username: json['username'] as String,
        score: json['score'] as int,
        mode: json['mode'] as String,
        image: Uint8List.fromList((json['image'] as String).codeUnits),
      );

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "score": score,
      "mode": mode,
      "image": String.fromCharCodes(image!),
    };
  }
}
