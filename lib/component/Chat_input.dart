import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:riderapp/controller/chat_controller.dart';
import 'package:riderapp/models/ChatMessage.dart';
import 'package:riderapp/models/api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatInputField extends StatelessWidget {
  ChatInputField({
    Key? key,
  }) : super(key: key);

  final messageController = TextEditingController();

  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://avn-websocket.onrender.com'),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20 * 0.75,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xfff833477).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: 20 / 4),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Your message....",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (messageController.text != '') {
                          sendChat();
                        }
                      },
                      icon: Icon(Icons.send),
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendChat() async {
    var idRider = Hive.box('id');
    String riderID = idRider.get(0);

    var sendChatTemp = Hive.box('sendingChatID');
    String sendingChatID = sendChatTemp.get(0);

    var now = DateTime.now();
    String date = "${now.year}-${now.month}-${now.day}";
    String time = "${now.hour}:${now.minute}:${now.second}";

    String chatID = 'CH';
    var url3 = Uri.parse("${Api().path}/Chat");
    var response = await http.get(url3);
    List<ChatMessage> listChats = ChatMessageFromJson(response.body);
    if (listChats.isNotEmpty) {
      int lastChatID = 0;
      String tempchatID = listChats[0].chatID;
      var tempchatIDArr = tempchatID.split('CH');
      lastChatID = int.parse(tempchatIDArr[1]);

      for (var a in listChats) {
        if (a.chatID != tempchatID) {
          String tempchatID2 = a.chatID;
          var tempchatIDArr2 = tempchatID2.split('CH');
          if (int.parse(tempchatIDArr2[1]) > lastChatID) {
            lastChatID = int.parse(tempchatIDArr2[1]);
          }
        }
      }
      chatID = "$chatID${(lastChatID + 1).toString()}";
    } else {
      chatID = "${chatID}1";
    }

    var url = Uri.parse(
        "${Api().path}/Chat/Create?keyword1=$chatID&keyword2=$date&keyword3=$time&keyword4=${messageController.text}&keyword5=$sendingChatID&keyword6=$riderID");
    await http.post(url);

    ChatMessage newMsg = ChatMessage(
        text: messageController.text,
        chatID: chatID,
        date: date,
        time: time,
        sendingChatID: sendingChatID,
        sender: riderID);

    Chat_Controller().add(chat: newMsg);

    _channel.sink.add(jsonEncode({
      "Id": newMsg.chatID,
      "Date": newMsg.date,
      "Time": newMsg.time,
      "Message": newMsg.text,
      "SendingChatId": newMsg.sendingChatID,
      "Sender": newMsg.sender,
    }));

    messageController.text = '';
  }
}
