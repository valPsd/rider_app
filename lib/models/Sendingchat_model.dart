import 'dart:convert';

List<SendingChat> SendingChatFromJson(String str) =>
    List<SendingChat>.from(json.decode(str).map((x) => SendingChat.fromJson(x)));

class SendingChat {
  SendingChat({
    required this.sendingChatID,
    required this.riderID,
    required this.userID,
    required this.orderID,
  });

  String sendingChatID;
  String riderID;
  String userID;
  String orderID;

  factory SendingChat.fromJson(Map<String, dynamic> json) => SendingChat(
        sendingChatID: json["id"],
        riderID: json["riderID"],
        userID: json["userID"],
        orderID: json["orderID"]
      );
}
