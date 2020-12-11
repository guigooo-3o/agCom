import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/auth_controller.dart';
import 'package:agendador_comunitario/controller/base_controller.dart';
import 'package:agendador_comunitario/controller/dialog_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:flutter/cupertino.dart';

class LoginController extends BaseController {
  final AuthenticationController _authenticationController = locator<
      AuthenticationController>();
  final DialogController _dialogController = locator<DialogController>();
  final NavigationController _navigationController = locator<
      NavigationController>();

  Future login({@required String email, @required String password}) async {
    setBusy(true);

    var result = await _authenticationController.loginWithEmail(
        email: email, password: password);

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationController.navigateTo(HomePageRoute);
      } else {
        await _dialogController.showDialog(
          title: 'Falha ao entrar.',
          description: 'Algo deu errado, por favor tente novamente mais tarde.',
        );
      }
    } else {
      await _dialogController.showDialog(
        title: 'Falha ao entrar.',
        description: result,
      );
    }
  }
}
