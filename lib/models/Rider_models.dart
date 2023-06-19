import 'dart:convert';

List<UserRider> riderFromJson(String str) =>
    List<UserRider>.from(json.decode(str).map((x) => UserRider.fromJson(x)));

class UserRider {
  UserRider({
    required this.riderID,
    required this.verifyID,
    required this.username,
    required this.password,
    required this.phoneNum,
    required this.name,
    required this.surname,
    required this.profile,
  });

  String riderID;
  String verifyID;
  String username;
  String password;
  String phoneNum;
  String name;
  String surname;
  String profile;

  factory UserRider.fromJson(Map<String, dynamic> json) => UserRider(
        riderID: json["riderID"],
        verifyID: json["verifyID"],
        password: json["password"],
        username: json["username"],
        phoneNum: json["phoneNum"],
        name: json["name"],
        surname: json["surname"],
        profile: json["profilePic"],
      );
}
