import 'dart:convert';

List<RiderLog> riderLogFromJson(String str) =>
    List<RiderLog>.from(json.decode(str).map((x) => RiderLog.fromJson(x)));

class RiderLog {
  RiderLog({
    required this.logID,
    required this.verifyID,
    required this.action,
    required this.reason
  });

  String logID;
  String verifyID;
  String action;
  String reason;

  factory RiderLog.fromJson(Map<String, dynamic> json) => RiderLog(
        logID: json["logID"],
        verifyID: json["verifyID"],
        reason: json["reason"],
        action: json["action"]
      );
}
