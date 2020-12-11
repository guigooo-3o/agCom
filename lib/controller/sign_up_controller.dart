
import 'dart:async';
import 'dart:io';

import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/auth_controller.dart';
import 'package:agendador_comunitario/controller/base_controller.dart';
import 'package:agendador_comunitario/controller/cloud_storage_controller.dart';
import 'package:agendador_comunitario/controller/cloud_storage_result.dart';
import 'package:agendador_comunitario/controller/dialog_controller.dart';
import 'package:agendador_comunitario/controller/firestore_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/model/city.dart';
import 'package:agendador_comunitario/model/user.dart';
import 'package:agendador_comunitario/util/image_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpController extends BaseController {
  final AuthenticationController _authenticationController = locator<
      AuthenticationController>();
  final DialogController _dialogController = locator<DialogController>();
  final NavigationController _navigationController = locator<
      NavigationController>();
  final ImageSelector _imageSelector = locator<ImageSelector>();
  final CloudStorageController _cloudStorageController = locator<CloudStorageController>();
  final FirestoreController _firestoreController= locator<FirestoreController>();
  final CollectionReference _cityCollectionReference = FirebaseFirestore.instance.collection("cities");
  final StreamController<List<City>> _citiesController= StreamController<List<City>>.broadcast();

  File _selectedImage;
  File get selectedImage => _selectedImage;

  Future selectImage() async {
    var tempImage= await _imageSelector.selectImage();
    if (tempImage!=null){
      _selectedImage = tempImage;
      notifyListeners();
    }
  }

  Future signUp({@required String email, @required String password, @required fullName, @required address, @required birthdate, @required photoUrl}) async {
    setBusy(true);
    _firestoreController.addCity(new City(cidade: address));
    CloudStorageResult storageResult;
    var result;
    if (_selectedImage!=null) {
      storageResult = await _cloudStorageController.uploadImage(
          imageToUpload: _selectedImage, title: "image");

      result = await _authenticationController.signUpWithEmail(
          email: email,
          password: password,
          fullName: fullName,
          address: address,
          birthdate: birthdate,
          photoUrl: storageResult.imageUrl);
    }else {
      result = await _authenticationController.signUpWithEmail(
          email: email,
          password: password,
          fullName: fullName,
          address: address,
          birthdate: birthdate,
          photoUrl: "",
      );
    }
    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationController.navigateTo(HomePageRoute);
      } else {
        await _dialogController.showDialog(
          title: 'Falha no cadastro.',
          description: 'Algo deu errado, por favor tente novamente mais tarde.',
        );
      }
    } else {
      await _dialogController.showDialog(
        title: 'Falha no cadastro.',
        description: result,
      );
    }
  }

  void editUser(AppUser user) async {
    setBusy(true);
    CloudStorageResult storageResult;
    var result;
    if (_selectedImage!=null) {
      storageResult = await _cloudStorageController.uploadImage(
          imageToUpload: _selectedImage, title: "image");

      result = await _firestoreController.updateUser(AppUser(
          id: currentUser.id,
          email: user.email,
//          password: user.password,
          fullName: user.fullName,
          address: user.address,
          birthdate: user.birthdate,
          photoUrl: storageResult.imageUrl
      ),
      );
    }else {
      result = await _firestoreController.updateUser(AppUser(
        id: currentUser.id,
        email: user.email,
//        password: user.password,
        fullName: user.fullName,
        address: user.address,
        birthdate: user.birthdate,
        photoUrl: currentUser.photoUrl,
      )
      );
    }
    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationController.navigateTo(HomePageRoute);
      } else {
        await _dialogController.showDialog(
          title: 'Falha no cadastro.',
          description: 'Algo deu errado, por favor tente novamente mais tarde.',
        );
      }
    } else {
      await _dialogController.showDialog(
        title: 'Falha no cadastro.',
        description: result,
      );
    }
  }
}
