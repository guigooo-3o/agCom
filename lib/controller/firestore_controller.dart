import 'dart:async';

import 'package:agendador_comunitario/model/activity.dart';
import 'package:agendador_comunitario/model/city.dart';
import 'package:agendador_comunitario/model/notification.dart';
import 'package:agendador_comunitario/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController{
  final CollectionReference _usersCollectionReference= FirebaseFirestore.instance.collection('users');
  final CollectionReference _activitiesCollectionReference = FirebaseFirestore.instance.collection("activities");
  final CollectionReference _cityCollectionReference = FirebaseFirestore.instance.collection("cities");

  final StreamController<List<Activity>> _activityController= StreamController<List<Activity>>.broadcast();
  final StreamController<List<Activity>> _myActivityController= StreamController<List<Activity>>.broadcast();
  final StreamController<List<AppUser>> _usersController= StreamController<List<AppUser>>.broadcast();
  final StreamController<List<AppNotification>> _notificationController= StreamController<List<AppNotification>>.broadcast();

  Future createUser (AppUser user) async {
    try{
      await _usersCollectionReference.doc(user.id).set(user.toJson());
    } catch (e){
      return e.toString();
    }
  }

  Future getUser (String uid) async {
    try{
      var userData= await _usersCollectionReference.doc(uid).get();
      return AppUser.fromData(userData.data());
    }catch (e){
      return e.toString();
    }
  }

  Future updateUser (AppUser user) async {
    try {
      await _usersCollectionReference.doc(user.id).update(user.toJson());
      return true;
    } catch (e){
      e.toString();
    }
  }

  Future addCity (City city) async {
    try{
      if (city.cidade.isNotEmpty)
        await _cityCollectionReference.doc(city.cidade).set(city.toMap());
    } catch (e){
      return e.toString();
    }
  }

  Future addActivity(Activity activity) async {
    try{
      await addCity(new City (cidade: activity.address));
      await _activitiesCollectionReference.add(activity.toMap());
      return true;
    }catch (e){
      return e.toString();
    }
  }

  Future updateActivity (Activity activity) async {
    try {
      await _activitiesCollectionReference.doc(activity.documentId).update(activity.toMap());
      return true;
    } catch (e){
      e.toString();
    }
  }

  // Stream listenToActivitiesByUserRealTime(AppUser user){
  //   try {
  //     _activitiesCollectionReference.snapshots()
  //         .listen((activitiesSnapshot) {
  //       if (activitiesSnapshot.docs.isNotEmpty) {
  //         var activities = activitiesSnapshot.docs.map((snapshot) =>
  //             Activity.fromMap(snapshot.data(), snapshot.id)).where((
  //             mappedItem) => mappedItem.title != null).toList();
  //
  //         _activityController.add(activities);
  //       }
  //     });
  //     return _activityController.stream;
  //   }catch (e){
  //     e.toString();
  //   }
  // }

  Stream listenToDeletedActivitiesRealTime(String id){
    try {
      // FirebaseFirestore.instance.collectionGroup('activities').where('id', isEqualTo: id).snapshots().listen((activitiesSnapshot) {
      //   if (activitiesSnapshot.docs.isNotEmpty){
      //     var activities = activitiesSnapshot.docs.map((snapshot) =>
      //         Activity.fromMap(snapshot.data(), snapshot.id))
      //         .where((mappedItem) => mappedItem.title != null && mappedItem.status != null &&
      //         (mappedItem.status != "Created" ||
      //             mappedItem.status != "Expired")).toList();
      //
      //     //TODO testar trocar esse controller se n der certo
      //     _activityController.add(activities);
      //   }
      // });
      _activitiesCollectionReference.where('status', isEqualTo: 'Deleted').snapshots().listen((activitiesSnapshot) {
        if (activitiesSnapshot.docs.isNotEmpty) {
          var activities = activitiesSnapshot.docs.map((snapshot) =>
              Activity.fromMap(snapshot.data(), snapshot.id))
              .where((mappedItem) =>
          mappedItem.title != null && mappedItem.status != null && (mappedItem.status != "Created" ||
              mappedItem.status != "Expired")).toList();

          _myActivityController.add(activities);
        }
      });
      return _myActivityController.stream;
    }catch (e) {
      e.toString();
    }
  }

  Stream listenToCreatedActivitiesRealTime(){
    try {
      _activitiesCollectionReference.where('status', isEqualTo: 'Created').snapshots().listen((activitiesSnapshot) {
        if (activitiesSnapshot.docs.isNotEmpty) {
          var activities = activitiesSnapshot.docs.map((snapshot) =>
              Activity.fromMap(snapshot.data(), snapshot.id))
              .where((mappedItem) =>
          mappedItem.title != null && mappedItem.status != null &&
              (mappedItem.status != "Deleted" ||
                  mappedItem.status != "Expired")).toList();

          _activityController.add(activities);
        }
      });
      return _activityController.stream;
    }catch (e) {
      e.toString();
    }
  }

  Stream listenToLstUsersInActivity(Activity activity) {
    try {
      _activitiesCollectionReference.doc(activity.documentId).collection(
          'users').snapshots().listen((usersSnapshot) {
        if (usersSnapshot.docs.isNotEmpty) {
          var users = usersSnapshot.docs.map((snapshot) =>
              AppUser.fromMap(snapshot.data())).where((mappedItem) =>
          mappedItem.fullName != null).toList();

          _usersController.add(users);
        }
      });
      return _usersController.stream;
    } catch (e) {
      e.toString();
    }
  }

  Stream listenToUsersNotifications(AppUser user) {
    try {
      _usersCollectionReference.doc(user.id).collection(
          'notifications').snapshots().listen((notificationsSnapshot) {
        if (notificationsSnapshot.docs.isNotEmpty) {
          var notifications = notificationsSnapshot.docs.map((snapshot) =>
              AppNotification.fromMap(snapshot.data(), snapshot.id)).where((mappedItem) =>
          mappedItem.title != null).toList();

          _notificationController.add(notifications);
        }
      });
      return _notificationController.stream;
    } catch (e) {
      e.toString();
    }
  }
}