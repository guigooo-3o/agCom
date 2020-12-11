import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/model/activity.dart';
import 'package:agendador_comunitario/model/chat.dart';
import 'package:agendador_comunitario/view/Login.dart';
import 'package:agendador_comunitario/view/SignUp.dart';
import 'package:agendador_comunitario/view/create_activity.dart';
import 'package:agendador_comunitario/view/home_page.dart';
import 'package:agendador_comunitario/view/info_atividades.dart';
import 'package:agendador_comunitario/view/info_atividades_bottom_menu.dart';
import 'package:agendador_comunitario/view/info_atividades_historico.dart';
import 'package:agendador_comunitario/view/minhas_atividades.dart';
import 'package:agendador_comunitario/view/offline_home.dart';
import 'package:agendador_comunitario/view/online_home.dart';
import 'package:agendador_comunitario/view/perfil.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case MyActivityPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MinhasAtividades(),
      );
    case InfoActivityMenu:
      var args= settings.arguments as Chat;
//      var activityToShow= settings.arguments as Activity;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: BottomMenu(
          showingActivity: args.activity,
          currentUser: args.user,
        ),
      );
    case InfoActivityHistoricoPageRoute:
      var activityToShow = settings.arguments as Activity;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: InformacaoAtividadesHistorico(
          showingActivity: activityToShow,
        ),
      );
    case InfoActivityPageRoute:
      var activityToShow = settings.arguments as Activity;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: InformacaoAtividades(
          showingActivity: activityToShow,
        ),
      );
    case CreateActivityPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: CreateActivityPage(),
      );
    case ProfilePageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProfilePage(),
      );
    case LoginPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginPage(),
      );
    case SignUpPageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpPage(),
      );
    case HomePageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomePage(),
      );
    case OfflineHomePageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: OfflineHomePage(),
      );
    case OnlineHomePageRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: OnlineHomePage(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('No route defined for ${settings.name}')),
          ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
