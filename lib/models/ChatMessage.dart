import 'dart:convert';

enum ChatMessageType { text }

enum MessageStatus { not_sent, not_view, viewed }

List<ChatMessage> ChatMessageFromJson(String str) =>
    List<ChatMessage>.from(json.decode(str).map((x) => ChatMessage.fromJson(x)));

class ChatMessage {
  final String chatID;
  final String date;
  final String time;
  final String text;
  final String sendingChatID;
  final String sender;
  // final ChatMessageType messageType;
  // final MessageStatus messageStatus;
  // final bool isSender;

  ChatMessage({
    required this.text,
    required this.chatID,
    required this.date,
    required this.time,
    required this.sendingChatID,
    required this.sender
    // required this.messageType,
    // required this.messageStatus,
    // required this.isSender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        chatID: json["id"],
        text: json["message"],
        date: json["date"],
        time: json["time"],
        sendingChatID: json["sendingChatId"],
        sender: json["sender"],
      );
}
