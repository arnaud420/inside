import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inside/Models/User.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  final Firestore _db = Firestore.instance;

  String setOneToOneChat(String uid1, String uid2) {
    int a = uid1.compareTo(uid2);
    int b = uid2.compareTo(uid1);
    if (a < b) {
      return uid1 + uid2;
    } else {
      return uid2 + uid1;
    }
  }

  Stream<QuerySnapshot> getMessages(User currentUser, User userMatched) {
    String chatDocId = this.setOneToOneChat(currentUser.uid, userMatched.uid);

    return _db
      .collection('chats')
      .document(chatDocId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .limit(50)
      .snapshots();
  }

  Future<void> postMessage(String message, User currentUser, User userMatched) async {
    String chatDocId = this.setOneToOneChat(currentUser.uid, userMatched.uid);

    try {
      await _db
        .collection('chats')
        .document(chatDocId)
        .collection('messages')
        .document(Uuid().v4())
        .setData({
          'content': message,
          'receiverId': userMatched.uid,
          'senderId': currentUser.uid,
          'timestamp': Timestamp.now()
        });
    } catch(e) {
      throw(e);
    }
  }
}