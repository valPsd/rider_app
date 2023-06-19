import 'dart:convert';

List<Restuarant> restuarantFromJson(String str) =>
    List<Restuarant>.from(json.decode(str).map((x) => Restuarant.fromJson(x)));

class Restuarant {
  Restuarant({
    required this.storeID,
    required this.name,
    required this.username,
    required this.password,
    required this.telNum,
    required this.email,
    required this.address
  });

  String storeID;
  String name;
  String username;
  String password;
  String telNum;
  String email;
  String address;

  factory Restuarant.fromJson(Map<String, dynamic> json) => Restuarant(
        storeID: json["storeID"],
        name: json["name"],
        password: json["password"],
        username: json["username"],
        telNum: json["tel_Num"],
        email: json["email"],
        address: json["address"]
      );
}
