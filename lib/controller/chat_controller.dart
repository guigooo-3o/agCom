
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController {
  final _firestore= FirebaseFirestore.instance;
  final String activityId;

  ChatController(this.activityId);

  Future<QuerySnapshot> getUserMessages({String loggedInUserEmail}) async {
//    var userMessages = await _firestore
//        .collection('messages')
//        .where('sender', isEqualTo: loggedInUserEmail)
//        .getDocuments();
    var userMessages= await  _firestore.collection('activities').doc(activityId).collection('messages').where('sender', isEqualTo: loggedInUserEmail).get();
    return userMessages;
  }

  Future<QuerySnapshot> getAllMessages() async {
//    var messages = await _firestore.collection('messages').getDocuments();
    var messages= await  _firestore.collection('activities').doc(activityId).collection('messages').get();
    return messages;
  }

  void addMessage({Map<String, dynamic> messageInstance}) {
//    _firestore.collection('messages').add(messageInstance);
    _firestore.collection('activities').doc(activityId).collection('messages').add(messageInstance);
  }
}