class Chatroom {
  String? chatroomID;
  List<String>? participant;

  Chatroom({this.chatroomID, this.participant});

  Chatroom.fromMap(Map<String, dynamic> map) {
    chatroomID = map["chatroomID"];
    participant = map["participant"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomID": chatroomID,
      "participant": participant,
    };
  }
}
