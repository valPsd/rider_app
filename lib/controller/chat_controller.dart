import 'package:flutter/cupertino.dart';
import 'package:riderapp/models/ChatMessage.dart';

class Chat_Controller extends ValueNotifier<List<ChatMessage>> {
  Chat_Controller._sharedInstance() : super([]);
  static final Chat_Controller _shared = Chat_Controller._sharedInstance();
  factory Chat_Controller() => _shared;

  int get length => value.length;

  void add({required ChatMessage chat}) {
    final chats = value;
    chats.add(chat);
    notifyListeners();
  }

  void remove({required ChatMessage chat}) {
    final chats = value;
    if (chats.contains(chat)) {
      chats.remove(chat);
      notifyListeners();
    }
  }

  void clear() {
    value.clear();
    notifyListeners();
  }

  ChatMessage? address({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
}
