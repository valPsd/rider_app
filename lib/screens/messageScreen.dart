import 'package:flutter/material.dart';
import 'package:riderapp/component/body.dart';
import 'package:riderapp/models/User_models.dart';
import 'package:riderapp/models/api.dart';

class MessageCsreen extends StatefulWidget {
  MessageCsreen({super.key, required this.user, required this.sendChatID});

  User user;
  String sendChatID;

  @override
  State<MessageCsreen> createState() => _MessageCsreenState();
}

class _MessageCsreenState extends State<MessageCsreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppbar(),
        body: Body(
          sendChatID: widget.sendChatID,
        ));
  }

  AppBar buildAppbar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 101, 57, 223),
              Color.fromARGB(255, 196, 42, 196),
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          widget.user.character == 0
              ? CircleAvatar(
                  backgroundImage: AssetImage("assets/images/female.png"),
                  radius: 20,
                )
              : CircleAvatar(
                  backgroundImage: AssetImage("assets/images/male.png"),
                  radius: 20,
                ),
          SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${widget.user.username}",
                  style: TextStyle(
                      color: Color.fromARGB(255, 235, 231, 231),
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5,
              ),
              Text(
                "Customer",
                style: TextStyle(
                  color: Color.fromARGB(255, 214, 210, 214),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
      // actions: [
      //   IconButton(onPressed: () {}, icon: Icon(Icons.local_phone)),
      //   SizedBox(
      //     width: 10,
      //   ),
      // ],
    );
  }
}
