import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/base_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/model/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:agendador_comunitario/model/notification.dart';
import 'package:http/http.dart' as http;

class NotificationController extends BaseController{
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final NavigationController _navigationController= locator<NavigationController>();
  final CollectionReference _usersCollectionReference= FirebaseFirestore.instance.collection('users');

  // Future initialise() async {
  //   if (Platform.isIOS){
  //     _fcm.requestNotificationPermissions(IosNotificationSettings());
  //   }
  //
  //   _fcm.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print ('onMessage: $message');
  //       _serializeAndNavigate(message, false);
  //       return;
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print ('onLaunch: $message');
  //       _serializeAndNavigate(message, true);
  //       return;
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print ('onResume: $message');
  //       _serializeAndNavigate(message, true);
  //       return;
  //     },
  //   );
  // }


  void subscribe(String id){
    _fcm.subscribeToTopic(id);
  }

  void unsubscribe (String id){
    _fcm.unsubscribeFromTopic(id);
  }

  void sendNotification(Activity activity) async{
    sendAndRetrieveMessage(activity.title, activity.documentId);
  }

  void _serializeAndNavigate(Map<String, dynamic> message, bool redirect){
    var notificationData = message['data'];
    AppNotification n= new AppNotification(title: notificationData['title'], body: notificationData['body'], activityId: notificationData['activityId'], userId: currentUser.id);
    addNotification(n);
    if (redirect)
      _navigationController.navigateTo(HomePageRoute);
  }

  void addNotification(AppNotification notification) {
    _usersCollectionReference.doc(currentUser.id).collection(
        'notifications').add(notification.toJson());
  }

  final String serverToken = 'AAAAS3HKaBk:APA91bGzbJwJM7cYuLNjsnPg-8zfEKuuSVF9W1mkcrOJ4_JvfDwEepbcOTDKPjNZJ2zragrnCkywA784yHReYO1qH6_uHT5SbxPiM_NYIAWmv5gDQAfHolhR0eYsM5MhPv7r6xBEl53x';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<Map<String, dynamic>> sendAndRetrieveMessage(name, topic) async {
    // await firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    // );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'A atividade $name foi removida',
            'title': 'Atividade cancelada'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'title': 'Atividade cancelada',
            'body': 'A atividade "$name" foi removida',
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'activityId': '$topic'
          },
          'to': '/topics/$topic',
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print ('onMessage: $message');
        _serializeAndNavigate(message, false);
        return;
      },
      onLaunch: (Map<String, dynamic> message) async {
        print ('onLaunch: $message');
        _serializeAndNavigate(message, true);
        return;
      },
      onResume: (Map<String, dynamic> message) async {
        print ('onResume: $message');
        _serializeAndNavigate(message, true);
        return;
      },
    );

    return completer.future;
  }
}