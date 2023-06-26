import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riderapp/controller/chat_controller.dart';
import 'package:riderapp/models/ChatMessage.dart';
import 'package:riderapp/component/Chat_input.dart';
import 'package:riderapp/component/massage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Body extends StatefulWidget {
  Body({super.key, required this.sendChatID});

  String sendChatID;
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // final _channel = WebSocketChannel.connect(
  //   Uri.parse('wss://avn-websocket.onrender.com'),
  // );

  String riderID = "";

  @override
  void initState() {
    var idRider = Hive.box('id');
    riderID = idRider.get(0);

    FirebaseFirestore.instance.collection("Chats").snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            print("New City: ${change.doc.data()}");
            // if (widget.sendChatID == change.doc.data()!['SendingChatId'] &&
            //     change.doc.data()!['Sender'] != riderID) {
            //   ChatMessage newChat = ChatMessage(
            //       text: change.doc.data()!['Message'],
            //       chatID: change.doc.data()!['Id'],
            //       date: change.doc.data()!['Date'],
            //       time: change.doc.data()!['Time'],
            //       sendingChatID: change.doc.data()!['SendingChatId'],
            //       sender: change.doc.data()!['Sender']);
            //   Chat_Controller().add(chat: newChat);
            // }
            break;
          case DocumentChangeType.modified:
            print("Modified City: ${change.doc.data()}");
            if (widget.sendChatID == change.doc.data()!['SendingChatId'] &&
                change.doc.data()!['Sender'] != riderID) {
              ChatMessage newChat = ChatMessage(
                  text: change.doc.data()!['Message'],
                  chatID: change.doc.data()!['Id'],
                  date: change.doc.data()!['Date'],
                  time: change.doc.data()!['Time'],
                  sendingChatID: change.doc.data()!['SendingChatId'],
                  sender: change.doc.data()!['Sender']);
              Chat_Controller().add(chat: newChat);
            }
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            break;
        }
      }
    });

    // _channel.stream.listen((onData) {
    //   Map<String, dynamic> data = json.decode(onData);
    //   if (widget.sendChatID == data['SendingChatId'] &&
    //       data['Sender'] != riderID) {
    //     ChatMessage newChat = ChatMessage(
    //         text: data['Message'],
    //         chatID: data['Id'],
    //         date: data['Date'],
    //         time: data['Time'],
    //         sendingChatID: data['SendingChatId'],
    //         sender: data['Sender']);
    //     Chat_Controller().add(chat: newChat);
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: Chat_Controller(),
              builder: (context, value, child) {
                final List<ChatMessage> listChat = value.reversed.toList();
                // listChat.sort((a, b) {
                //   String splitAndReplaceA = (a.date.split(" "))[0];
                //   var splitDateA;
                //   if (splitAndReplaceA.contains("/")) {
                //     splitDateA = splitAndReplaceA.split("/");
                //   } else {
                //     splitDateA = splitAndReplaceA.split("-");
                //   }
                //   if (splitDateA[1].length == 1) {
                //     splitDateA[1] = "0${splitDateA[0]}";
                //   }
                //   String newDateA =
                //       "${splitDateA[0]}-${splitDateA[1]}-${splitDateA[2]}";

                //   String splitAndReplaceB = (b.date.split(" "))[0];
                //   var splitDateB;
                //   if (splitAndReplaceB.contains("/")) {
                //     splitDateB = splitAndReplaceB.split("/");
                //   } else {
                //     splitDateB = splitAndReplaceB.split("-");
                //   }
                //   if (splitDateB[1].length == 1) {
                //     splitDateB[1] = "0${splitDateB[0]}";
                //   }
                //   String newDateB =
                //       "${splitDateB[0]}-${splitDateB[1]}-${splitDateB[2]}";
                //   return DateTime.parse("$newDateB ${b.time}.000000")
                //       .compareTo(DateTime.parse("$newDateA ${a.time}.000000"));
                // });
                return ListView.builder(
                  reverse: true,
                  itemCount: listChat.length,
                  itemBuilder: (context, index) =>
                      Message(message: listChat[index]),
                );
              }),
        ),
        ChatInputField(),
      ],
    );
  }
}
