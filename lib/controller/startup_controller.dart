import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/auth_controller.dart';
import 'package:agendador_comunitario/controller/base_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/controller/notification_controller.dart';

class StartUpController extends BaseController{
  final AuthenticationController _authenticationController = locator<AuthenticationController>();
  final NavigationController _navigationController= locator<NavigationController>();
  final NotificationController _notificationController= locator<NotificationController>();

  Future handleStartUpLogic() async {

    // await _notificationController.initialise();

    var hasLoggedInUser= await _authenticationController.isUserLoggedIn();

    if (hasLoggedInUser){
      _navigationController.navigateTo(OnlineHomePageRoute);
    }else{
      _navigationController.navigateTo(OfflineHomePageRoute);
    }
  }
}