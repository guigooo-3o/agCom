
import 'package:agendador_comunitario/controller/firestore_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthenticationController {
  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  final FirestoreController _firestoreController= locator<FirestoreController>();

  AppUser _currentUser;
  AppUser get currentUser => _currentUser;

  Future loginWithEmail({@required String email, @required String password}) async {
    try{
      var authResult= await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      await _populateCurrentUser(authResult.user);
      return authResult.user !=null;
    } catch (e){
      return e.toString();
    }
  }

  Future signUpWithEmail({@required String email, @required String password, @required fullName, @required address, @required birthdate, photoUrl}) async {
    try{
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      _currentUser = AppUser(
          id: authResult.user.uid,
          email: email,
//          password: password,
          fullName: fullName,
          address: address,
          birthdate: birthdate,
          photoUrl: photoUrl
      );

      await _firestoreController.createUser(_currentUser);

      return authResult.user!=null;
    } catch (e){
      return e.toString();
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    await _populateCurrentUser(user);
    return user != null;
  }

  Future<void> SignOut() {
    _currentUser= null;
    return _firebaseAuth.signOut();
  }

  Future _populateCurrentUser(User user) async {
    if (user!=null){
      _currentUser = await _firestoreController.getUser(user.uid);
    }
  }
}