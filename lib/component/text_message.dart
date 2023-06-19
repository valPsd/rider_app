import 'package:flutter/material.dart';
import 'package:riderapp/models/ChatMessage.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
    this.riderID
  }) : super(key: key);

  final ChatMessage? message;
  final String? riderID;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: MediaQuery.of(context).platformBrightness == Brightness.dark
      //     ? Colors.white
      //     : Color.fromARGB(255, 17, 15, 15),
      padding: EdgeInsets.symmetric(
        horizontal: 20 * 0.75,
        vertical: 20 / 2,
      ),
      decoration: BoxDecoration(
        color: Color(0xfff833477).withOpacity(message!.sender == riderID ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        message!.text,
        style: TextStyle(
          color: message!.sender == riderID
              ? Colors.white
              : Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
  }
}
