import 'dart:convert';

List<VerifyRider> verifyFromJson(String str) => List<VerifyRider>.from(
    json.decode(str).map((x) => VerifyRider.fromJson(x)));

class VerifyRider {
  VerifyRider({
    required this.verifyID,
    required this.verifyStatusID,
    required this.adminID,
    required this.faceImage,
    required this.cardImage,
  });

  String verifyID;
  String verifyStatusID;
  String adminID;
  String faceImage;
  String cardImage;

  factory VerifyRider.fromJson(Map<String, dynamic> json) => VerifyRider(
        verifyID: json["id"],
        verifyStatusID: json["verifyStatusID"],
        adminID: json["adminID"],
        faceImage: json["faceImage"],
        cardImage: json["cardImage"],
      );
}
