class MessageModel{
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdDate;

  MessageModel({this.messageId, this.sender, this.text, this.seen, this.createdDate});

  MessageModel.fromMap(Map<String, dynamic> map){
    messageId = map['messageId'];
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createdDate = map['createdDate'].toDate();
  }

  Map<String, dynamic> toMap(){
    return{
      'messageId': messageId,
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdDate': createdDate
    };
  }
}