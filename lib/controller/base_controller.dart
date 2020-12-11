import 'package:agendador_comunitario/controller/auth_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/model/user.dart';
import 'package:flutter/widgets.dart';

class BaseController extends ChangeNotifier {

  final AuthenticationController _authenticationController = locator<AuthenticationController>();

  AppUser get currentUser => _authenticationController.currentUser;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
