import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/base_controller.dart';
import 'package:agendador_comunitario/controller/dialog_controller.dart';
import 'package:agendador_comunitario/controller/firestore_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/controller/notification_controller.dart';
import 'package:agendador_comunitario/model/activity.dart';
import 'package:agendador_comunitario/model/user.dart';
import 'package:agendador_comunitario/model/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityBaseController extends BaseController{
  final FirestoreController _firestoreController= locator<FirestoreController>();
  final DialogController _dialogController = locator<DialogController>();
  final NavigationController _navigationController= locator<NavigationController>();
  final NotificationController _notificationController = locator<NotificationController>();
  final CollectionReference _activitiesCollectionReference = FirebaseFirestore.instance.collection("activities");
  final CollectionReference _usersCollectionReference = FirebaseFirestore.instance.collection("users");

  List<Activity> _activities;
  List<Activity> get activities=> _activities;

  List<Activity> _myActivities;
  List<Activity> get myActivities=> _myActivities;

  List<Activity> _myPastActivities;
  List<Activity> get myPastActivities=> _myPastActivities;

//  List<AppUser> _otherUsers;
//  List<AppUser> get otherUsers=> _otherUsers;

  List<AppUser> _users;
  List<AppUser> get users=> _users;

  List<AppNotification> _notifications;
  List<AppNotification> get notifications=> _notifications;

  bool isDeleteAccepted= false;

  Future insertUser (Activity activity, AppUser user){
    if (users!=null) {
      if (users.length < activity.numberParticipants)
        //TODO melhor solução
        _activitiesCollectionReference.doc(activity.documentId).collection(
            'users').doc(user.id).set(user.toJson());
      // _activitiesCollectionReference.doc(activity.documentId).collection(
      //             'users').add(user.toJson());
      else
        _dialogController.showDialog(
            title: "Erro ao tentar ingressar na atividade.",
            description: "Atividade está cheia."
        );
    } else {
      _activitiesCollectionReference.doc(activity.documentId).collection(
          'users').doc(user.id).set(user.toJson());
      // _activitiesCollectionReference.doc(activity.documentId).collection(
      //     'users').add(user.toJson());
    }
    _notificationController.subscribe(activity.documentId);
    notifyListeners();
  }

  void getListUsers(Activity activity){
    setBusy(true);

    _firestoreController.listenToLstUsersInActivity(activity).listen((usersData) {
      List<AppUser> updatedUsers= usersData;
      if (updatedUsers != null && updatedUsers.length > 0){
        _users= updatedUsers;
        notifyListeners();
      }

      setBusy(false);
    });
  }

  void getUserNotifications(){
    setBusy(true);

    _firestoreController.listenToUsersNotifications(currentUser).listen((usersData) {
      List<AppNotification> updatedNotifications= usersData;
      if (updatedNotifications != null && updatedNotifications.length > 0){
        _notifications= updatedNotifications;
        notifyListeners();
      }

      setBusy(false);
    });
  }

//  Future getListOtherUsers(Activity activity){
//    setBusy(true);
//
//    _firestoreController.listenToLstUsersInActivity(activity).listen((usersData) {
//      List<AppUser> updatedUsers= usersData;
//      if (updatedUsers != null && updatedUsers.length > 0){
//        updatedUsers.forEach((element) {
//          _otherUsers.add(element);
//        });
//        notifyListeners();
//      }
//
//      setBusy(false);
//    });
//  }

  bool isUserInActivity() {
    bool isEquals= false;
    if (currentUser!=null) {
      if (_users != null) {
        users.forEach((element) {
          if (element.id == currentUser.id) {
            isEquals = true;
          }
        });
      }
    }
    return isEquals;
  }

  bool isUserInActivityChat(Activity activity) {
    bool isEquals= false;
    getListUsers(activity);
    if (_users != null) {
      users.forEach((element) {
        if (element.id == currentUser.id) {
          isEquals= true;
        }
      });
    }
    return isEquals;
  }

  Future confirmDelete () async{
    isDeleteAccepted= false;
    var dialogResponse = await _dialogController.showConfirmationDialog(
      title: "Deletar atividade",
      description: "Tem certeza que deseja deletar a atividade?",
      confirmationTitle: 'Sim',
      cancelTitle: 'Não',
    );
    if (dialogResponse.confirmed){
      isDeleteAccepted=true;
    }
  }

 Future deleteActivityWithNoUsers(String documentId) async {
     try {
       await _activitiesCollectionReference.doc(documentId).delete();
     } catch (e){
       e.toString();
     }
 }

  Future<Activity> getActivityById(String documentId) async {
  try{
    var activity= await _activitiesCollectionReference.doc(documentId).get();
    return Activity.fromMap(activity.data(), documentId);
  } catch (e){
    e.toString();
   }
 }

 Future removeNotification(AppNotification notification) async {
   try {
     await _usersCollectionReference.doc(currentUser.id).collection('notifications').doc(notification.id).delete();
   } catch (e){
     e.toString();
   }
 }

  Future deleteActivity(Activity activity) async {
    var result;
    setBusy(true);
    if (_users!= null) {
      result = await _firestoreController.updateActivity(Activity(
        title: activity.title,
        creator: activity.creator,
        type: activity.type,
        status: "Deleted",
        documentId: activity.documentId,
        hour: activity.hour,
        date: activity.date,
        typeDescription: activity.typeDescription,
        price: activity.price,
        numberParticipants: activity.numberParticipants,
        address: activity.address,
        description: activity.description,
      ),
      );

      if (result is bool) {
        if (result) {
          _navigationController.navigateTo(HomePageRoute);
        } else {
          await _dialogController.showDialog(
            title: 'Falha ao deletar atividade.',
            description: 'Algo deu errado, por favor tente novamente mais tarde.',
          );
        }
      } else {
        await _dialogController.showDialog(
          title: 'Falha ao deletar.',
          description: result,
        );
      }
    } else {
      deleteActivityWithNoUsers(activity.documentId);
      _notificationController.sendNotification(activity);
      // _users.forEach((element) {
      //   var name = activity.title;
      //   AppNotification n= new AppNotification(title: 'Atividade cancelada', body: 'A atividade "$name" foi removida', activityId: activity.documentId, userId: currentUser.id);
      //   _notificationController.addNotification(n);
      // });
      _navigationController.navigateTo(HomePageRoute);
    }
    // _users.forEach((element) {
    //   var name = activity.title;
    //   AppNotification n= new AppNotification(title: 'Atividade cancelada', body: 'A atividade "$name" foi removida', activityId: activity.documentId, userId: currentUser.id);
    //   _notificationController.addNotification(n);
    // });
    _notificationController.sendNotification(activity);
    notifyListeners();
    setBusy(false);
  }

  Future getUserIdInActivity (String documentId, String uid) async {
    String userId;
    try {
      await _activitiesCollectionReference
          .doc(documentId)
          .collection('users')
          .where("id", isEqualTo: uid).get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          userId = result.id;
        });
      });
      return userId;
    } catch (e){
      e.toString();
    }
  }

  Future deleteUserInActivity(String documentId, String uid) async {
    try {
      // String userId = await getUserIdInActivity(documentId, uid);
      await _activitiesCollectionReference.doc(documentId)
          .collection('users')
          .doc(uid)
          .delete();
      _notificationController.unsubscribe(documentId);
      notifyListeners();
    } catch (e) {
      e.toString();
    }
  }

  void listenToActivities(){
    setBusy(true);

    _firestoreController.listenToCreatedActivitiesRealTime().listen((activitiesData) {
      List<Activity> updatedActivities= activitiesData;
      if (updatedActivities != null && updatedActivities.length > 0){
        _activities= updatedActivities;
        notifyListeners();
      }

      setBusy(false);
    });
  }

  void listenToMyPastActivities(){
    setBusy(true);
    if (currentUser!= null) {
    //   _firestoreController.listenToDeletedActivitiesRealTime(currentUser.id).listen((activitiesData) {
    //     List<Activity> updatedActivities= activitiesData;
    //     if (updatedActivities!=null && updatedActivities.length>0){
    //       _myPastActivities= updatedActivities;
    //       notifyListeners();
    //     }
    //
    //     setBusy(false);
    //   });
      _firestoreController.listenToDeletedActivitiesRealTime(currentUser.id).listen((activitiesDataHist) {
        List<Activity> updatedActivitiesHist = activitiesDataHist;
        if (updatedActivitiesHist != null && updatedActivitiesHist.length > 0) {
          updatedActivitiesHist.forEach((element) async {
            List<Activity> tempListHist = List<Activity>();
            String userId = await getUserIdInActivity(element.documentId, currentUser.id);
            if (userId!=null) {
              tempListHist.add(element);
            }
            if (tempListHist.isNotEmpty)
              if (_myPastActivities != null) {
                if (_myPastActivities.every((activity) => activity.documentId != element.documentId))
                  _myPastActivities.add(element);
                  notifyListeners();
              } else {
                _myPastActivities = tempListHist;
                notifyListeners();
              }
            setBusy(false);
          });
        }
      });
    }
  }

  void listenToMyActivities() {
    setBusy(true);
    _firestoreController.listenToCreatedActivitiesRealTime().listen((activitiesData){
      List<Activity> updatedActivities = activitiesData;
      if (updatedActivities != null && updatedActivities.length > 0) {
        updatedActivities.forEach((element) async {
          List<Activity> tempList= List<Activity>();
          String userId= await getUserIdInActivity(element.documentId, currentUser.id);
          if (userId!=null){
              tempList.add(element);
          }
          if (tempList.isNotEmpty)
            if (_myActivities!=null){
              if (_myActivities.every((activity) => activity.documentId!=element.documentId))
                _myActivities.add(element);
            } else {
              _myActivities = tempList;
          }
          notifyListeners();
        });
      }
      setBusy(false);
    });
  }

  Future addActivity({
    @required type,
    @required title,
    date,
    hour,
    description,
    address,
    numberParticipants,
    price,
    typeDescription,
    status,

  }) async {
    setBusy(true);
    var result= await _firestoreController.addActivity(Activity(title: title, creator: currentUser.id, type: type, description: description, address: address, date: date, hour: hour, numberParticipants: numberParticipants, price: price, typeDescription: typeDescription, status: status));
    setBusy(false);

    if (result is String){
      await _dialogController.showDialog(
        title: 'Não foi possível criar a atividade',
        description: result,
      );
    } else {
      await _dialogController.showDialog(
          title: 'Atividade criada com sucesso.',
          description: 'Sua atividade foi adicionada'
      );
    }
    notifyListeners();
    _navigationController.pop();
  }
}