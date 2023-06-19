import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riderapp/controller/chat_controller.dart';
import 'package:riderapp/models/ChatMessage.dart';
import 'package:riderapp/component/text_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    String getRiderID() {
      var idRider = Hive.box('id');
      return idRider.get(0);
    }

    Widget messageContaint(ChatMessage message) {
      return TextMessage(
        message: message,
        riderID: getRiderID().toString(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: message.sender == getRiderID().toString()
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  '${(message.date.split(" "))[0]}  ${message.time}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: message.sender == getRiderID().toString()
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              // if (message.isSender) ...[
              //   CircleAvatar(
              //     radius: 12,
              //     backgroundImage: AssetImage("assets/images/varang.jpg"),
              //   ),
              //   SizedBox(width: 20 / 2),
              // ],
              messageContaint(message),
              // if (message.isSender)
              //   MessageStatusDot(status: message.messageStatus)
            ],
          ),
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return Color(0xFFF03738);
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return Color(0xFF00BF6D);
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: 20 / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
