import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String content;
  final String receiverId;
  final String senderId;
  final Timestamp timestamp;

  Message({ this.content, this.receiverId, this.senderId, this.timestamp });

  factory Message.fromMap(DocumentSnapshot doc) {
    Map data = doc.data;
  
    return Message(
      content: data['content'] ?? '',
      receiverId: data['receiverId'] ?? '',
      senderId: data['senderId'] ?? '',
      timestamp: data['timestamp'] ?? '',
    );
  }
}