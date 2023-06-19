import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

class User {
  User({
    required this.userID,
    required this.username,
    required this.password,
    required this.phoneNum,
    required this.email,
    required this.character,
  });

  String userID;
  String username;
  String password;
  String phoneNum;
  String email;
  int character;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userID: json["id"],
        password: json["password"],
        username: json["username"],
        phoneNum: json["phoneNum"],
        email: json["email"],
        character: json["character"],
      );
}
